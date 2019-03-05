module Lexical
  class Lexeme
    def initialize(code, line, column)
      @code = code
      @line = line
      @column = column
    end

    def to_s
      "#{@code}: (#{@line}, #{@column})"
    end
  end
end
