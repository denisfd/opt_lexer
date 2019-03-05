module Lexical
  class Lexeme
    def initialize(value, code, line, column)
      @value = value
      @code = code
      @line = line
      @column = column
    end

    def to_s
      "#{@code}: (#{@line}, #{@column}) => #{@value}"
    end
  end
end
