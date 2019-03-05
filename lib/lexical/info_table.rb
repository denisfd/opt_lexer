module Lexical
  class InfoTable
    def initialize
      @symbols = []
      @symbol_code = 50

      @keywords = []
      @keyword_code = 300

      @identifiers = []
      @ident_code = 400

      @constants = []
      @const_code = 500
    end

    def recognize(token, line, column)
      return if token.empty?
      column += 1
      puts "#{line}, #{column} #{token}"

    end

    def add_symbol(symb)
      return if @symbols.include?(symb)

      @symbols.push({ value: symb, code: @symbol_code })
      @symbol_code += 1
    end

    def add_keyword(keyword)
      return if @keywords.include?(keyword)

      @keywords.push({ value: keyword, code: @keyword_code })
      @keyword_code += 1
    end

    def add_identifier(ident)
      return if @identifiers.include?(ident)

      @identifiers.push({ value: ident, code: @ident_code })
      @ident_code += 1
    end

    def add_const(const)
      return if @constants.include?(const)

      @constants.push({ value: const, code: @const_code })
      @const_code += 1
    end

    def report
      print_table("Symbols", @symbols)
      print_table("Keywords", @keywords)
      print_table("Identifiers", @identifiers)
      print_table("Constants", @constants)
    end

    def print_table(name, table)
      puts "Table #{name}:"

      table.each do |row|
        puts "#{row[:code]}: #{row[:value]}"
      end
      puts "-------------------"
    end
  end
end
