#!/usr/bin/env ruby

require 'clamp'
require 'pry'

require './lib/lexical'
require './lib/syntax'
require './lib/code'

class LexerCommand < Clamp::Command
  option ['-f', '--file'], 'filename', 'Input File', required: true

  def execute
    lexer = Lexical.create({
      casesensetive: false,
    })
    lexer.scan_file(file)
    lexer.report

    parser = Syntax.create(lexer: lexer)
    puts parser.akm
    parser.report

    generator = Code.create(tree: parser.tree.children[0])
    puts
    generator.generate("output.txt")
  end
end

class Main < Clamp::Command
  subcommand 'lexer', 'Run Lexical Analysis', LexerCommand
end

Main.run
