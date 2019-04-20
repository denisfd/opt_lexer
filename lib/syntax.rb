require './lib/syntax/parser.rb'

module Syntax
  def self.create(lexer:)
    parser = Parser.new(table: lexer.infotable)
  end
end
