#!/usr/bin/env ruby

require 'clamp'
require 'pry'

require './lib/lexical'
require './lib/syntax'

class LexerCommand < Clamp::Command
  option ['-f', '--file'], 'filename', 'Input File', required: true

  def execute
    lexer = Lexical.create({
      casesensetive: false,
    })

    lexer.scan_file(file)

    lexer.report

    syntax = Syntax.create(lexer: lexer)
  end
end

class Main < Clamp::Command
  subcommand 'lexer', 'Run Lexical Analysis', LexerCommand
end

Main.run
