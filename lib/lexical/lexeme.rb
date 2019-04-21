module Lexical
  class Lexeme
    attr_reader :value, :code, :line, :column, :type

    def initialize(value, code, line, column, type)
      @value = value
      @code = code
      @line = line
      @column = column
      @type = type
    end

    def to_s
      "#{@code}: (#{@line}, #{@column}) => #{@value} [#{@type.to_s}]"
    end
  end
end
