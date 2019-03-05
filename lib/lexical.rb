Dir['./lib/lexical/**/*.rb'].each { |f| require f }

module Lexical
  DEFAULTS = {
    casesensetive: false
  }
  def self.create(params = {})
    it = InfoTable.new

    [':', ',', '.', ';', '[', ']'].each { |s| it.add_symbol(s) }

    [
      'PROGRAM',
      'VAR',
      'INTEGER',
      'FLOAT',
      'BEGIN',
      'LOOP',
      ':=',
      'ENDLOOP',
      'END'
    ].each do |word|
      it.add_keyword(word)
    end

    lexer = Lexer.new(it, DEFAULTS.merge(params))

    lexer
  end
end
