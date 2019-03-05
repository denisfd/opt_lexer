module Lexical
  class Error
    attr_reader :line, :column, :message

    def initialize(line, column, message)
      @line = line
      @column = column
      @message = message
    end

    def to_s
      "#{line}, #{column} => #{message}"
    end
  end
end
