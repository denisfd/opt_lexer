module Code
  class Generator
    def initialize(root)
      @tree = root
      @labels = []
      @declarations = []
    end

    def generate(filename)
      output = process_node(@tree)
      puts output
      File.open(filename, 'w') { |file| file.write(output) }
    end

    def visit_nodes(list)
      list = Array(list)
      list.inject("") { |str, c| str + process_node(c) }
    end

    def process_node(node)
      return "" if node.nil?

      case node.value
      when '<signal-program>'
        ".model small\n.stack 100h\n\n" + visit_nodes(node.children)

      when '<program>'
        @proc_name = visit_nodes(node.children[1])
        visit_nodes(node.children[3..4])
      when 'BEGIN'
        @proc_name + " proc\n"
      when '.'
        @proc_name + " endp\n"
      when '<variable-declarations>'
        ".data\n" + visit_nodes(node.children)
      when '<declaration>'
        name = visit_nodes(node.children[0].children)
        @declarations.push(name)
        type = visit_nodes(node.children[2].children)
        asm_type = (type == 'FLOAT') ? 'dq' : 'dw'
        value = '?'
        if node.children.length == 5
          range = node.children[3].children[0].children[1]
          first = visit_nodes(range.children[0]).to_i
          last = visit_nodes(range.children[2]).to_i
          value = (first..last).map(&:to_s).join(', ')
        end
        "#{name} #{asm_type} #{value}\n"
      when "LOOP"
        label = "L" + @labels.length.to_s
        @labels.push(label)
        label + ":\n"
      when "ENDLOOP"
        "jmp " + @labels.pop + "\n"
      when '<variable-identifier>'
        name = visit_nodes(node.children)
        puts "ERROR: Variable #{name} is not declared" unless @declarations.include?(name)
        name
      when '<statement>'
        if node.children[0].value == 'LOOP'
          visit_nodes(node.children)
        else
          expression(node)
        end
      when '<procedure-identifier>', '<identifier>', '<block>', '<declaration-list>',
            '<attribute-list>', '<unsigned-integer>', '<statements-list>'
        visit_nodes(node.children)
      when "VAR", "END", ";"
        ""
      else
        node.value
      end
    end

    def expression(node)
      dest_moves, dest = destination(node.children[0])
      source_moves, source = source(node.children[2])

      "#{source_moves}mov ax, #{source}\n#{dest_moves}mov #{dest}, ax\n"
    end

    def source(node)
      node = node.children[0]
      if node.children.length == 1
        return "", visit_nodes(node.children)
      end
      movs = dimension(node.children[1], "")
      name = visit_nodes(node.children[0].children)
      return movs + "\n", "#{name}[ebx]"
    end

    def destination(node)
      if node.children.length == 1
        return "", visit_nodes(node.children)
      end
      movs = dimension(node.children[1], "")
      name = visit_nodes(node.children[0].children)
      return movs + "\n", "#{name}[ebx]"
    end

    def dimension(node, str)
      child = node.children[1]
      child = child.children[0] if child.value == '<expression>'
      name = visit_nodes(child.children[0].children)
      child = child.children[1] if child.value == '<variable>'

      if child.value == '<dimension>'
        str = dimension(child, str) + "\nmov ebx, #{name}[ebx]" + str
      else
        return "mov ebx, #{visit_nodes(child.children)}"
      end
      str
    end
  end
end