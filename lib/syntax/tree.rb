module Syntax
  class Node
    attr_reader :value, :parent, :children

    def initialize(value, parent)
      @value = value
      @parent = parent
      @children = []
    end

    def append(value)
      child = Node.new(value, self)
      @children.push child

      child
    end

    def print(decor = "")
      puts decor + @value

      @children.each { |node| node.print(decor + "_") }
    end
  end
end