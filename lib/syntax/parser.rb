require './lib/syntax/table.rb'
require './lib/syntax/tree.rb'

module Syntax
  class Parser
    def initialize(table:)
      @infotable = table
      @table = Table.form

      @tokens = @infotable.lexems
      @tokens.push(Lexical::Lexeme.new('#', 0, 0, 0, :meta))

      @result
    end

    def akm
      stack = []
      index = 0
      @root = Node.new('root', nil)
      @error = nil
      state = { ind: -1, rule: '<start>', node: @root }
      address = ''

      while true
        @error = @tokens[index - 1] if address == 'ERROR'

        if address == 'F' || address == 'T'
          state = stack.pop

          rule = @table[state[:rule]][state[:ind]]
          address = (address == 'T') ? rule[1] : rule[2]

          next
        end

        return 'OK' if address == 'OK'
        return 'ERROR' if address == 'ERROR'

        if address == ''
          state[:ind] += 1
        else
          state[:ind] = address
        end

        binding.pry if @table[state[:rule]].nil?
        rule = @table[state[:rule]][state[:ind]]

        # pp rule
        if definition?(rule[0])
          stack.push(state)

          state = { ind: -1, rule: rule[0], node: state[:node].append(rule[0]) }
          address = ''

          next
        else
          if rule[0][0] == '<'
            if rule[0] == '<identifier>'
              if @tokens[index].type == :ident
                state[:node].append(rule[0]).append(@tokens[index].value, true)
                index += 1
                address = rule[1]
              else
                address = rule[2]
              end
            elsif rule[0] == '<unsigned-integer>'
              if @tokens[index].type == :const
                state[:node].append(rule[0]).append(@tokens[index].value, true)
                index += 1
                address = rule[1]
              else
                address = rule[2]
              end
            else
            address = rule[2]
            end
          else
            if @tokens[index].value == rule[0]
              # keywords and symbs
              state[:node].append(rule[0], true)
              index += 1
              address = rule[1]
            else
              address = rule[2]
            end
          end
        end
      end
    end

    def definition?(str)
      return false if str[0] != '<'
      return false if ['<identifier>', '<unsigned-integer>', '<empty>'].include?(str)
      return true
    end

    def report
      if @error
        puts "An error occured at line #{@error.line}, near synbol #{@error.value} (column #{@error.column})"
      else
        @root.finitize!
        @root.print
      end
    end

    def tree
      @root
    end
  end
end