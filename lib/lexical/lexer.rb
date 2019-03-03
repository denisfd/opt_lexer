module Lexical
  class Lexer
    def initialize
    end

    def parse_file(file_name)
      parse(File.read(file_name))
    end

    def parse(text)
      puts 'Parsing'
      puts text
    end

    def report
      puts 'Printing Tables'
    end
  end
end
