Dir['./lib/lexical/**/*.rb'].each { |f| require f }

module Lexical
  DEFAULTS = {
    casesensetive: false
  }
  def self.create(params = {})
    it = InfoTable.new

    lexer = Lexer.new(it, DEFAULTS.merge(params))

    lexer
  end
end
