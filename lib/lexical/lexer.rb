module Lexical
  class Lexer
    attr_reader :infotable

    def initialize(infotable, params)
      @infotable = infotable
      @config = params
      @comment = false
      @comment_line = 0
      @comment_column = 0
    end

    def scan_file(file_name)
      scan(File.read(file_name))
    end

    def scan(text)
      text = text.upcase if !@config[:casesensetive]

      text.each_line.with_index do |line, index|
        line = line.rstrip + ' '
        tokenize_line(line, index)
      end
      if @comment
        @infotable.add_error(Error.new(@comment_line, @comment_column, 'Comment opened but not closed'))
      end
    end

    def tokenize_line(line, index)
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
            @infotable.recognize(token, index, i - token.length)
            token = ''
            @comment = true
            @comment_line = index + 1
            @comment_column = i + 1
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
              if line[i] == '.' && !(line[i + 1] == '.' || (i >= 1 && line[i-1] == '.'))
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
      @infotable.report
    end
  end
end
