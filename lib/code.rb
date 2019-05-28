require './lib/code/generator.rb'

module Code
  def self.create(tree:)
    generator = Code::Generator.new(tree)
  end
end