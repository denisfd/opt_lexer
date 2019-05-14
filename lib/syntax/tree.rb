module Syntax
  class Node
    attr_reader :value, :parent, :children

    def initialize(value, parent, finite = false)
      @value = value
      @parent = parent
      @finite = finite
      @children = []
    end

    def append(value, finite = false)
      child = Node.new(value, self, finite)
      @children.push child

      child
    end

    def print(decor = "")
      puts decor + @value

      @children.each { |node| node.print(decor + "_") }
    end

    def finitize!
      delete if !finite?

      @children.each(&:finitize!)
    end

    def finite?
      return true if @finite
      @children.each { |c| return true if c.finite? }
      return false
    end

    def delete
      @parent.children.delete(self)
    end
  end
end