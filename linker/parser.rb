class InvalidOp
  attr_accessor :msg, :op
  def initialize(message, op)
    @msg = message
    @op = op
  end
end

class ParamError
  attr_accessor :msg, :param
  def initialize(message, param)
    @msg = message
    @param = param
  end
end

def declare(map, start, string)
  count = start
  string.split(" ").each do |token|
    map[token] = count
    count += 1
  end
end

HEX_RE = /^0x([0-9a-fA-F]+)$/
INT_RE = /^(\d+)$/

INSTRUCTIONS = {}
EXTENDED_INSTRUCTIONS = {}
REGISTERS = {}
VALUES = {}

declare(INSTRUCTIONS, 1, "set add sub mul div mod shl shr and bor xor ife ifn ifg ifb")
declare(EXTENDED_INSTRUCTIONS, 1, "jsr")
declare(REGISTERS, 0, "a b c x y z i j h")
declare(VALUES, 0x18, "pop peek push sp pc O")


REGISTER_RE = /^([#{REGISTERS.keys.join('')}])$/i
INDIRECT_RE = /\[(.*)\]/i

VALUE_RE = /^(#{VALUES.keys.join('|')})$/

INDIRECT_REGISTER = 0x08
INDIRECT_REG_NEXT = 0x10

NEXT_INDIRECT = 0x1e
NEXT_LITERAL = 0x1f


$DONT_STOP_ON_ERROR = false


def parse_error_stop(reason, source_file, line_number, line)
  puts "FATAL LINK ERROR"
  puts "Error #{reason}"
  puts "in file #{source_file} on line #{line_number}"
  puts "Errant Line: #{line}"
  exit 1 unless $DONT_STOP_ON_ERROR
end

class Instruction
  attr_accessor :opcode, :a, :b, :next_words, :source, :line, :defined_symbols
  
  def initialize(opcode_token, param_a, param_b, defined_symbols, source_file, line_number)
    @opcode_token = opcode_token
    @param_a = param_a
    @param_b = param_b
    @source = source_file
    @line = line_number
    @defined_symbols = defined_symbols

    @op = INSTRUCTIONS[@opcode_token]

    if @op.nil? 
      @op = EXTENDED_INSTRUCTIONS[@opcode_token]
      if @op.nil?
        puts "Unknown instruction."
        exit 1
      end
      @extended = true
    end

    @a = parse_param(@param_a)
    @b = parse_param(@param_b) unless @extended

    @next_words = []
  end

  def parse_param(param_token)
    indirect = param_token =~ INDIRECT_RE
    if indirect
      param_token = $1.strip
    end
    
    if param_token =~ REGISTER_RE #it's a register
      reg_code = REGISTERS[$1]
      return REGISTERS[$1] + (indirect ? INDIRECT_REGISTER : 0)
    elsif param_token =~ VALUE_RE #it's one of the special magic values
      if indirect
        raise ParamError.new("#{param_token} cannot be used for indirection.", param_token)
      end
      return VALUES[param_token]
    end

    puts "Don't know how to handle: #{param_token}"

    return -1
  end

  def orig
    "#{@op.to_s} #{@a.to_s} #{@b.to_s} : #{@labels.join("\n")} #{@opcode_token} #{@param_a}, #{@param_b}"
  end
end

class InlineData
  
end

LINKAGE_VISIBILITY = [:global, :local, :hidden]
#A symbol. It might or might not be defined.
#By default, all symbols have a global visibility
#
#Private symbols are mangled before insertion into
#the program assembly. Not before.
#
#
class AsmSymbol
  attr_reader :orig_name, :def_instr, :linkage_vis, :first_file
  def initialize(first_file, orig_name, parent_symbol = nil)
    @orig_name = orig_name
    @first_file = first_file
    @parent = parent_symbol
    @linkage_vis = parent_symbol.nil? ? :global : :local
  end

  def define(instruction)
    @def_instr = instruction
  end

  def name
    case @linkage_vis
    when :global
      return @orig_name
    when :local
      return AsmSymbol::make_local_name(@parent, @orig_name)
    when :hidden
      #the first file will always be the correct file for private symbols.
      return AsmSymbol::make_private_name(@first_file, @parent, @orig_name)
    else 
      puts "Unsupported linkage visibility of #{@linkage_vis}"
      exit 1
    end
  end

  def self.make_local_name(parent_symbol, label)
    return "#{parent_symbol.name}$$#{label}"
  end

  def self.make_private_name(filename, parent, name)
      return "#{filename}$$#{parent.name}$$#{name}"
  end
end

#Represents a single .S module file.
class ObjectModule

  #Label on a line by itself
  LABEL_RE = /^:([a-z0-9\._]+)/i
  # :label instruction operand, operand
  LINE_RE = /^\s*(:[a-z0-9\._]+|\s*)(\w+)\s+(.+)\s*,\s*(.+)$/i
  # hidden global variables
  HIDDEN_SYM_RE = /^\.(hidden|private)\s+([a-z0-9\._])/i

  EXT_INSTR_RE = /^(:[a-zA-Z0-9\._]+|\s*)(\w+)\s+(.+)$/

  attr_accessor :lines
  #Create a module from source lines.
  def initialize(file_name, source_lines)
    @filename = file_name
    @lines = source_lines
    @instructions = []
    @module_symbols = {}
    @program_symbols = {}
    @module_private_symbols = []
  end

  #Clean and normalize the source
  def normalize
    @lines.map! {|line| line.gsub(/;.*$/, '').gsub(/\s+/, ' ').strip}
  end

  #Resolve a symbol in the current tables.
  def resolve(symbol_name, current_global = nil, filename)
    resolve_name = symbol_name
    if label.start_with?('.')
      if current_global.nil?
        puts "Cannot locate local symbol without global context."
        exit 1
      end
      resolve_name = AsmSymbol::make_local_name(current_global, symbol_name)
    end
    ###TODO not actually going to resolve anything right now
    "NO RESOLVE YET"
    exit 1
  end

  def empty_line(line)
    return (line.empty? || line =~ /^\s+$/) #skip empty lines or whitespace lines
  end

  def definitions_pass
    last_global_symbol = nil
    @lines.each_with_index do |line, line_number|
      next if empty_line(line)
      if line =~ LABEL_RE || line =~ LINE_RE
        if empty_line($1)
          next
        end
        label = $1.strip
        parent = nil
        if label.start_with?('.')
          parent = last_global_symbol
        end
        defined_symbol = AsmSymbol.new(@filename, label, parent)
        puts "Defined #{defined_symbol.name}"
        @module_symbols[defined_symbol.name] = defined_symbol
        last_global_symbol = defined_symbol if parent.nil?
      elsif line =~ HIDDEN_SYM_RE
        hidden_symbol = $2
        @module_private_symbols << hidden_symbol
      end
    end
  end

  def mangle_and_merge
    
  end

  def assemble

    pending_symbols = []
    last_global_symbol = nil #might also be hidden

    @lines.each_with_index do |line, line_number|

      if line.empty? || line =~ /^\s+$/ #skip empty lines or whitespace lines
        next
      end

      if line =~ LABEL_RE #this is a standalone symbol definition
        
      end

      unless line =~ LINE_RE || line =~ EXT_INSTR_RE
        parse_error_stop("Cannot parse line.", @filename, line_number, line)
      end

      label = $1
      instruction = $2.downcase
      param_a = $3
      param_b = $4
      
      unless label.nil? || label.empty?
        last_global_label, label = globalize_label(last_global_label, label, line_number, line)
        pending_labels << label
      end
      begin
        instr = Instruction.new(instruction, param_a, param_b, pending_labels, @filename, line_number)
        pending_labels = []
        puts instr.orig
      rescue ParamError => e
        parse_error_stop(e.msg, @filename, line_number, line)
      end
    end
  end

  #Parse the source file into an abstract representation.
  def parse
    definitions_pass()
  end

  def globalize_label(last_global_label, this_label, line_number, line)

    if this_label.start_with?('.') #is it a local label
      if last_global_label.nil?
        parse_error_stop("Local label without preceding global label.", @filename, line_number, line)
      end
      return [last_global_label, "#{last_global_label}$$#{this_label}"]
    end
    
    return [this_label, "#{this_label}"]
  end
end

# $DONT_STOP_ON_ERROR = true

if __FILE__ == $PROGRAM_NAME
  filename = "#{ARGV.first || "out.s"}"
  om = nil
  open(filename, 'r') do |file|
    om = ObjectModule.new(filename, file.readlines)
  end

  unless om.nil?
    om.normalize
#    puts om.lines
    om.parse
  end
end