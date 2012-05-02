# Autogenerated from a Treetop grammar. Edits may be lost.


module D16Asm
  include Treetop::Runtime

  def root
    @root ||= :parameters
  end

  module Parameters0
  end

  module Parameters1
    def indirect_or_direct
      elements[0]
    end

  end

  module Parameters2
			def content
				retval = []
				retval << elements[0].content
				if elements[1] && !elements[1].empty?
					retval.concat(elements[1].elements.map {|e| e.content})
				end
				retval
			end
  end

  def _nt_parameters
    start_index = index
    if node_cache[:parameters].has_key?(index)
      cached = node_cache[:parameters][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_indirect_or_direct
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_additional_param
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        s5, i5 = [], index
        loop do
          if has_terminal?('\G[ \\t]', true, index)
            r6 = true
            @index += 1
          else
            r6 = nil
          end
          if r6
            s5 << r6
          else
            break
          end
        end
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        if r5
          r4 = r5
        else
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s0 << r4
        if r4
          i8, s8 = index, []
          if has_terminal?(';', false, index)
            r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(';')
            r9 = nil
          end
          s8 << r9
          if r9
            s10, i10 = [], index
            loop do
              if index < input_length
                r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("any character")
                r11 = nil
              end
              if r11
                s10 << r11
              else
                break
              end
            end
            r10 = instantiate_node(SyntaxNode,input, i10...index, s10)
            s8 << r10
          end
          if s8.last
            r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
            r8.extend(Parameters0)
          else
            @index = i8
            r8 = nil
          end
          if r8
            r7 = r8
          else
            r7 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r7
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Parameters1)
      r0.extend(Parameters2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:parameters][start_index] = r0

    r0
  end

  module IndirectOrDirect0
  end

  module IndirectOrDirect1
    def expression
      elements[1]
    end

  end

  module IndirectOrDirect2
			def content
				retval = elements[1].content
				retval[:indirect] = !elements[0].empty?
				retval
			end
  end

  def _nt_indirect_or_direct
    start_index = index
    if node_cache[:indirect_or_direct].has_key?(index)
      cached = node_cache[:indirect_or_direct][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    i2, s2 = index, []
    if has_terminal?('[', false, index)
      r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r3 = nil
    end
    s2 << r3
    if r3
      s4, i4 = [], index
      loop do
        if has_terminal?('\G[ \\t]', true, index)
          r5 = true
          @index += 1
        else
          r5 = nil
        end
        if r5
          s4 << r5
        else
          break
        end
      end
      r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
      s2 << r4
    end
    if s2.last
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      r2.extend(IndirectOrDirect0)
    else
      @index = i2
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      r6 = _nt_expression
      s0 << r6
      if r6
        s8, i8 = [], index
        loop do
          if has_terminal?('\G[ \\t]', true, index)
            r9 = true
            @index += 1
          else
            r9 = nil
          end
          if r9
            s8 << r9
          else
            break
          end
        end
        r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
        if r8
          r7 = r8
        else
          r7 = instantiate_node(SyntaxNode,input, index...index)
        end
        s0 << r7
        if r7
          if has_terminal?(']', false, index)
            r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(']')
            r11 = nil
          end
          if r11
            r10 = r11
          else
            r10 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r10
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(IndirectOrDirect1)
      r0.extend(IndirectOrDirect2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:indirect_or_direct][start_index] = r0

    r0
  end

  module AdditionalParam0
    def comma
      elements[0]
    end

    def indirect_or_direct
      elements[1]
    end
  end

  module AdditionalParam1
			def content
				elements[1].content
			end
  end

  def _nt_additional_param
    start_index = index
    if node_cache[:additional_param].has_key?(index)
      cached = node_cache[:additional_param][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_comma
    s0 << r1
    if r1
      r2 = _nt_indirect_or_direct
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(AdditionalParam0)
      r0.extend(AdditionalParam1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:additional_param][start_index] = r0

    r0
  end

  module Comma0
  end

  def _nt_comma
    start_index = index
    if node_cache[:comma].has_key?(index)
      cached = node_cache[:comma][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?(',', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(',')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[ \\t]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Comma0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:comma][start_index] = r0

    r0
  end

  module Expression0
    def term
      elements[0]
    end

  end

  module Expression1
			def content
				retval = {:term => elements[0].content}
				if elements.length > 1 && elements[1].respond_to?('content')
					sub_expr = elements[1].content 
					retval[:rhs] = sub_expr[:expr]
					retval[:rhs][:term][:operator] = sub_expr[:operator]
				end
				retval
			end
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_term
    s0 << r1
    if r1
      i3 = index
      r4 = _nt_additive
      if r4
        r3 = r4
      else
        r5 = _nt_subtractive
        if r5
          r3 = r5
        else
          @index = i3
          r3 = nil
        end
      end
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Expression0)
      r0.extend(Expression1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  module Additive0
    def plus
      elements[0]
    end

    def expression
      elements[1]
    end
  end

  module Additive1
			def content
				{:operator => '+',
				 :expr => elements[1].content}
			end
  end

  def _nt_additive
    start_index = index
    if node_cache[:additive].has_key?(index)
      cached = node_cache[:additive][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_plus
    s0 << r1
    if r1
      r2 = _nt_expression
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Additive0)
      r0.extend(Additive1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:additive][start_index] = r0

    r0
  end

  module Subtractive0
    def minus
      elements[0]
    end

    def expression
      elements[1]
    end
  end

  module Subtractive1
			def content
				{:operator => '-',
				 :expr => elements[1].content}
			end
  end

  def _nt_subtractive
    start_index = index
    if node_cache[:subtractive].has_key?(index)
      cached = node_cache[:subtractive][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_minus
    s0 << r1
    if r1
      r2 = _nt_expression
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Subtractive0)
      r0.extend(Subtractive1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:subtractive][start_index] = r0

    r0
  end

  module Plus0
  end

  def _nt_plus
    start_index = index
    if node_cache[:plus].has_key?(index)
      cached = node_cache[:plus][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('+', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('+')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[ \\t]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Plus0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:plus][start_index] = r0

    r0
  end

  module Minus0
  end

  def _nt_minus
    start_index = index
    if node_cache[:minus].has_key?(index)
      cached = node_cache[:minus][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('-', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[ \\t]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Minus0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:minus][start_index] = r0

    r0
  end

  module Term0
  end

  module Term1
			def content
				elements[0].content
			end
  end

  def _nt_term
    start_index = index
    if node_cache[:term].has_key?(index)
      cached = node_cache[:term][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_register
    if r2
      r1 = r2
    else
      r3 = _nt_special_value
      if r3
        r1 = r3
      else
        r4 = _nt_literal
        if r4
          r1 = r4
        else
          r5 = _nt_reference
          if r5
            r1 = r5
          else
            @index = i1
            r1 = nil
          end
        end
      end
    end
    s0 << r1
    if r1
      s6, i6 = [], index
      loop do
        if has_terminal?('\G[ \\t]', true, index)
          r7 = true
          @index += 1
        else
          r7 = nil
        end
        if r7
          s6 << r7
        else
          break
        end
      end
      r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
      s0 << r6
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Term0)
      r0.extend(Term1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:term][start_index] = r0

    r0
  end

  module Decimal0
			def value
				text_value.to_i(10)
			end
  end

  def _nt_decimal
    start_index = index
    if node_cache[:decimal].has_key?(index)
      cached = node_cache[:decimal][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[0-9]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Decimal0)
    end

    node_cache[:decimal][start_index] = r0

    r0
  end

  module Hex0
  end

  module Hex1
			def value
				text_value[2..-1].to_i(16)
			end
  end

  def _nt_hex
    start_index = index
    if node_cache[:hex].has_key?(index)
      cached = node_cache[:hex][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('0x', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('0x')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[0-9a-fA-F]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Hex0)
      r0.extend(Hex1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:hex][start_index] = r0

    r0
  end

  module Literal0
  end

  module Literal1
			def content
				sign = 1
				if text_value.start_with? '-'
					sign = -1
				end
				{:type => :literal, :token => text_value, :value => elements[1].value * sign}
			end
  end

  def _nt_literal
    start_index = index
    if node_cache[:literal].has_key?(index)
      cached = node_cache[:literal][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('-', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      i3 = index
      r4 = _nt_hex
      if r4
        r3 = r4
      else
        r5 = _nt_decimal
        if r5
          r3 = r5
        else
          @index = i3
          r3 = nil
        end
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Literal0)
      r0.extend(Literal1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:literal][start_index] = r0

    r0
  end

  module Reference0
  end

  module Reference1
			def content
				{:type => :reference, :token => text_value}
			end
  end

  def _nt_reference
    start_index = index
    if node_cache[:reference].has_key?(index)
      cached = node_cache[:reference][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      if has_terminal?('\G[a-zA-Z\\._$]', true, index)
        r2 = true
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      @index = i1
      r1 = nil
    else
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        if has_terminal?('\G[a-zA-Z\\._0-9]', true, index)
          r4 = true
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Reference0)
      r0.extend(Reference1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:reference][start_index] = r0

    r0
  end

  module Register0
  end

  module Register1
			def content
				{:type => :register, :token => text_value.downcase}
			end
  end

  def _nt_register
    start_index = index
    if node_cache[:register].has_key?(index)
      cached = node_cache[:register][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[abcxyzijABCXYZIJ]', true, index)
      r1 = true
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      i2 = index
      if has_terminal?('\G[a-zA-Z0-9\\._$]', true, index)
        r3 = true
        @index += 1
      else
        r3 = nil
      end
      if r3
        r2 = nil
      else
        @index = i2
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Register0)
      r0.extend(Register1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:register][start_index] = r0

    r0
  end

  module SpecialValue0
  end

  module SpecialValue1
			def content
				{:type => :special, :token => text_value.downcase}
			end
  end

  def _nt_special_value
    start_index = index
    if node_cache[:special_value].has_key?(index)
      cached = node_cache[:special_value][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    i1 = index
    if has_terminal?('sp', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('sp')
      r2 = nil
    end
    if r2
      r1 = r2
    else
      if has_terminal?('SP', false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('SP')
        r3 = nil
      end
      if r3
        r1 = r3
      else
        if has_terminal?('pc', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('pc')
          r4 = nil
        end
        if r4
          r1 = r4
        else
          if has_terminal?('PC', false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('PC')
            r5 = nil
          end
          if r5
            r1 = r5
          else
            if has_terminal?('ex', false, index)
              r6 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('ex')
              r6 = nil
            end
            if r6
              r1 = r6
            else
              if has_terminal?('EX', false, index)
                r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure('EX')
                r7 = nil
              end
              if r7
                r1 = r7
              else
                if has_terminal?('push', false, index)
                  r8 = instantiate_node(SyntaxNode,input, index...(index + 4))
                  @index += 4
                else
                  terminal_parse_failure('push')
                  r8 = nil
                end
                if r8
                  r1 = r8
                else
                  if has_terminal?('PUSH', false, index)
                    r9 = instantiate_node(SyntaxNode,input, index...(index + 4))
                    @index += 4
                  else
                    terminal_parse_failure('PUSH')
                    r9 = nil
                  end
                  if r9
                    r1 = r9
                  else
                    if has_terminal?('pop', false, index)
                      r10 = instantiate_node(SyntaxNode,input, index...(index + 3))
                      @index += 3
                    else
                      terminal_parse_failure('pop')
                      r10 = nil
                    end
                    if r10
                      r1 = r10
                    else
                      if has_terminal?('POP', false, index)
                        r11 = instantiate_node(SyntaxNode,input, index...(index + 3))
                        @index += 3
                      else
                        terminal_parse_failure('POP')
                        r11 = nil
                      end
                      if r11
                        r1 = r11
                      else
                        @index = i1
                        r1 = nil
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    s0 << r1
    if r1
      i12 = index
      if has_terminal?('\G[a-zA-Z0-9\\._$]', true, index)
        r13 = true
        @index += 1
      else
        r13 = nil
      end
      if r13
        r12 = nil
      else
        @index = i12
        r12 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r12
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(SpecialValue0)
      r0.extend(SpecialValue1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:special_value][start_index] = r0

    r0
  end

end

class D16AsmParser < Treetop::Runtime::CompiledParser
  include D16Asm
end
