module Lexical
  class InfoTable
    attr_reader :delims

    def initialize
      @delims = [':', ',']
    end

    def recognize(token, line, column)
      return if token.empty?
      puts "#{line}, #{column} #{token}"
    end

    def report
      puts 'Printing InfoTable'
    end
  end
end
