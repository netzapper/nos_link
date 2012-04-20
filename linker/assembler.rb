require_relative 'resolve.rb'


def link_error_stop(e, filename, abs_line)
  puts "FATAL LINK ERROR"
  puts "Error: #{e.msg}"
  puts "in file #{filename} on line #{abs_line[:line_number] + 1}"
  puts "Errant Line: #{abs_line[:original_line]}"
  puts e.backtrace if $config[:hacking]
  exit 1 unless $DONT_STOP_ON_ERROR
end

#
#
# Responsible for resolving references while
# also building the binary. Woo!
#
class Assemblinker
  def initialize(symbols, modules)
    @symbols = symbols
    @modules = modules
    @leading_instructions = []
    @trailing_instructions = []
    
    define_special_labels()
  end
  
  def define_special_labels
    @end_symbol = AsmSymbol.new("[none]", '_end', nil)
    @end_symbol.define(NullInstruction.new([@end_symbol]))
    @symbols[@end_symbol.name] = @end_symbol
  end
  
  def instr_list
    list = []
    instructions.each do |instr|
      list << instr
    end
    list
  end
  
  def instructions
    if @iter.nil?
      @iter = InstrIter.new(@modules, @leading_instructions, @trailing_instructions)
    end
    return @iter
  end
  
  class InstrIter
    def initialize(mods, leading, trailing)
      @leading = leading
      @mods = mods
      @trailing = trailing
    end
    
    def size
      accum = 0
      @mods.each do |mod|
        accum += mod.instructions.size
      end
    end
    
    def each
      
      @leading.each do |instr|
          yield instr
      end
      
      @mods.each do |mod|
        mod.instructions.each do |instr|
          yield instr
        end
      end
      
      @trailing.each do |instr|
          yield instr
      end
    end
  end

  def resolve_data_label_refs(instr) 
    instr.words.map! do |word|
      if word.class != String
        word
      else
        ref_sym = resolve(@symbols, instr.source, word, instr.scope)
        ref_sym.referenced
        if ref_sym.nil?
          raise LinkError.new("Unfulfilled link error. Trying to find: #{word}")
        end
        ref_sym
      end
    end
  end

  # Resolve all instruction parameters.
  # At this stage, the program is done in an abstract sense.
  # All that's left is turning the abstract instructions into binary.
  def assemble
    instructions.each do |instr|
      begin
        
        if instr.class == InlineData
          resolve_data_label_refs(instr)
          next
        end
        
        next unless instr.class == Instruction
        resolve_param(instr, instr.a)
        resolve_param(instr, instr.b)
      rescue LinkError => e
        link_error_stop(e, instr.source, instr.abs_line)
      end
    end
    
    if @end_symbol.referenced?
      @trailing_instructions << @end_symbol.def_instr
    end
  end
  
  # Get a list of all unreferenced symbols in the program.
  def get_unref_symbols
    unref = []
    @modules.each do |mod|
      mod.symbols.values.each do |s|
        unless s.referenced?
          unref << s.name
        end
      end
    end
    unref
  end

  # Fix all instructions into their address space.
  def fix
    assembled_address = $config[:base_address]
    instructions.each do |instr|
      instr.fix(assembled_address)
      assembled_address += instr.size
    end
#    if @end_symbol.referenced?
#      @end_symbol.def_instr.words << assembled_address
#    end
  end

  # Have each instruction generate its binary code.
  def realize
    instructions.each do |instr|
      begin
        instr.realize
      rescue LinkError => e
        link_error_stop(e, instr.source, instr.abs_line)
      end
    end
  end

  # Write the binary into the given stream.
  def binary(output)
    if instructions.size == 0
      puts "No instruction stream. Cannot create binary."
      error 1
    end

    instructions.each do |instr|
      instr_bytes = instr.words
      encstr = 'n' * instr_bytes.size
      output << instr_bytes.pack(encstr)
    end
  end

  # Print a side-by-side assembly/binary listing.
  def print_hex_and_instr
    instructions.each do |instr|
      instr_bytes = instr.words
      fstr = "%x " * instr_bytes.size
      puts "#{instr.to_s} \t ;#{fstr % instr_bytes}"
    end
  end

  # Resolve an instruction's parameter.
  def resolve_param(instr, param)
    if param.nil? || param.reference_token.nil?
      return
    end

    ref_sym = resolve(@symbols, instr.source, param.reference_token, instr.scope)
    if ref_sym.nil?
      raise LinkError.new("Unfulfilled link error. Trying to find: #{param.reference_token}")
    end

    param.resolve(ref_sym)
  end
end
