#!/usr/bin/env ruby

require 'clamp'
require 'pry'

require './lib/lexical'

class LexerCommand < Clamp::Command
  option ['-f', '--file'], 'filename', 'Input File', required: true

  def execute
    parser = Lexical.create({
      casesensetive: false,
    })

    parser.scan_file(file)

    parser.report
  end
end

class Main < Clamp::Command
  subcommand 'lexer', 'Run Lexical Analysis', LexerCommand
end

Main.run
