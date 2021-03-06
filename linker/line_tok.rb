require_relative 'abstract_asm.rb'

require 'treetop'
require_relative '../grammars/D16Asm'


SPACE = /\s+/i

def parse_instruction_line(ret_table, instr_tok, line_rem, allow_strings = nil)
  paramp = D16AsmParser.new
  
  parsed_params = paramp.parse(line_rem)
  if parsed_params.nil?
    reason = "Parameter parse failure. Parameter line: \"#{line_rem}\" \n"
    reason << "Failure reason: #{paramp.failure_reason()}\n"
    reason << "Input column: #{paramp.failure_column()}"
    raise ParseError.new(reason)
  end
  
  params = parsed_params.content.reject {|r| r.nil?}
  
  params.map! do |p|
    val = nil
    if p[:term][:type] == :string
      if allow_strings
        val = p[:term][:value]
      else
        raise ParseError.new("String literal not allowed in context.")
      end
    else
      val = p
    end
    val
  end
    
  ret_table[:params] = params
  ret_table
end


def tokenize_line(filename, line_no, line_str)
  ret_table = Hash.new
  ret_table[:original_line] = line_str
  ret_table[:line_number] = line_no
    
  part = ['blah', 'blah', line_str]
  while true  
    part = part[2].partition(SPACE)
    if part[0].empty?
      if part[2].empty?
        break
      end
      next
    end
    
    if part[0].start_with?(';')
      ret_table[:comment] = part[2]
      break
    end
    
    token = part[0].strip
    
    if token =~ LABEL_DEF
      raise ParseError.new("Parse error, redundant label definition.") if ret_table[:label]
      label = token.gsub(':', '').strip
      ret_table[:label] = label
      ret_table[:label_local] = label.start_with?('.')
      next
    end
    
    downtoken = token.downcase
    
    if ALL_INSTR.has_key?(downtoken) || DATA_DIRECTIVES.has_key?(downtoken)
      ret_table[:instr] = downtoken
      ret_table[:instr_rem] = part[2].strip
      parse_instruction_line(ret_table, ret_table[:instr], ret_table[:instr_rem], DATA_DIRECTIVES.has_key?(downtoken))
      break
    elsif DIRECTIVES.has_key?(downtoken)
      ret_table[:directive] = token.downcase
      ret_table[:directive_rem] = part[2].strip
      break
    elsif token.start_with?('.')
      unless token =~ NULL_DIR_RE
        parse_warning(filename, line_no, line_str, "Unknown directive '#{token}'.")
      end
      ret_table[:unknown_directive] = token.downcase
      ret_table[:unknown_directive_rem] = part[2]
      break
    else
      require 'ruby-debug/debugger'
      raise ParseError.new("Bad token: #{token}.")
    end
  end

  return ret_table
end
