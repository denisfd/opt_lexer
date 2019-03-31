module Lexical
  class InfoTable
    attr_reader :symbols, :keywords, :identifiers, :constants, :lexems, :errors

    def initialize
      @symbols = {}
      @symbol_code = 50

      @keywords = {}
      @keyword_code = 300

      @identifiers = {}
      @ident_code = 400

      @constants = {}
      @const_code = 500

      @lexems = []
      @errors = []
    end

    def recognize(token, line, column)
      return if token.empty?

      column += 1
      line += 1
      if present?(token, @symbols)
        @lexems.push(Lexeme.new(token, @symbols[token], line, column))
      elsif present?(token, @keywords)
        @lexems.push(Lexeme.new(token, @keywords[token], line, column))
      else
        if identifier?(token, line, column)
          add_identifier(token)
          @lexems.push(Lexeme.new(token, @identifiers[token], line, column))
        elsif constant?(token, line, column)
          add_const(token)
          @lexems.push(Lexeme.new(token, @constants[token], line, column))
        end
      end
    end

    def add_error(error)
      @errors.push(error)
    end

    def identifier?(token, line, column)
      model = token.upcase

      symbs = 'A'..'Z'
      digits = '0'..'9'

      return false unless symbs.include?(model[0])
      i = 0
      while i < model.length
        char = model[i]
        unless symbs.include?(char) || digits.include?(char)
          add_error(Error.new(line, column, "illegal symbol: #{char}"))
          return false
        end

        i+= 1
      end

      true
    end

    def constant?(token, line, column)
      digits = '0'..'9'
      i = 0

      while i < token.length
        unless digits.include?(token[i])
          add_error(Error.new(line, column, "illegal symbol: #{token[i]}"))
          return false
        end
        i += 1
      end

      true
    end

    def present?(symb, collection)
      collection.keys.include?(symb)
    end

    def add_symbol(symb)
      return if present?(symb, @symbols)

      @symbols[symb] = @symbol_code
      @symbol_code += 1
    end

    def add_keyword(keyword)
      return if present?(keyword, @keywords)

      @keywords[keyword] = @keyword_code
      @keyword_code += 1
    end

    def add_identifier(ident)
      return if present?(ident, @identifiers)

      @identifiers[ident] = @ident_code
      @ident_code += 1
    end

    def add_const(const)
      return if present?(const, @constants)

      @constants[const] = @const_code
      @const_code += 1
    end

    def report
      print_table("Symbols", @symbols)
      print_table("Keywords", @keywords)
      print_table("Identifiers", @identifiers)
      print_table("Constants", @constants)
      print_lexemes
      print_errors
    end

    def print_lexemes
      puts 'Table Lexemes:'
      puts 'code: (line, column) => value'
      @lexems.each { |lexeme| puts lexeme }
      puts "-------------------"
      puts
    end

    def print_errors
      puts 'Errors:'
      @errors.each { |e| puts e }
      puts "-------------------"
      puts
    end

    def print_table(name, table)
      puts "Table #{name}:"

      table.each do |k, v|
        puts "#{v}: #{k}"
      end
      puts "-------------------"
      puts
    end
  end
end
