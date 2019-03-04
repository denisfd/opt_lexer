module Lexical
  class Lexer
    def initialize(infotable, params)
      @infotable = infotable
      @config = params
      @comment = false
    end

    def scan_file(file_name)
      scan(File.read(file_name))
    end

    def scan(text)
      puts 'Scanning'
      text = text.upcase if !@config[:casesensetive]

      text.each_line.with_index do |line, index|
        line = line.split.join(' ') + ' '
        tokenize_line(line, index)
      end
    end

    def tokenize_line(line, index)
      pp "#{index} : #{line}"
      i = 0
      column = 0
      token = ''
      while i < line.length
        if @comment
          if line[i] == '*' && line[i + 1] == ')'
            @comment = false
            i += 1
          end
        else
          if line[i] == '(' && line[i + 1] == '*'
            @comment = true
            i += 1
          elsif line[i] == ' '
            @infotable.recognize(token, index, i - token.length)
            token = ''
          else
            if line[i] == ':'
              @infotable.recognize(token, index, i - token.length)
              if line[i + 1] == '='
                @infotable.recognize(':=', index, i)
                i += 2
              else
                @infotable.recognize(':', index, i)
                i += 1
              end
              token = ''
              next
            else
              if ['[', ']', ';'].include?(line[i])
                @infotable.recognize(token, index, i - token.length)
                @infotable.recognize(line[i], index, i)
                i += 1
                token = ''
                next
              end
            end
            token += line[i]
          end
        end
        i += 1
      end
    end

    def report
      puts 'Printing Tables'
      @infotable.report
    end
  end
end
