module Syntax
  class Table
    def self.form
      {
        '<signal-program>' => [['<program>', 'T', 'F']],
        '<program>' => [
          ['PROGRAM', '', 'F'],
          ['<procedure-identifier>', '', 'F'],
          [';', '', 'F'],
          ['<block>', '', 'F'],
          ['.', 'T', 'F']
        ],
        '<block>' => [
          ['<variable-declarations>', '', 'F'],
          ['BEGIN', '', 'F'],
          ['<statements-list>', '', 'F'],
          ['END', 'T', 'F']
        ],
        '<variable-declarations>' => [
          ['VAR', '', 2],
          ['<declaration-list>', 'T', 'F'],
          ['<empty>', 'T', 'T']
        ],
        '<declaration-list>' => [
          ['<declaration>', '', 'F'],
          ['<declaration-list>', 'T', 2],
          ['<empty>', 'T', 'T']
        ],
        '<declaration>' => [
          ['<variable-identifier>', '', 'F'],
          [':', '', 'F'],
          ['<attribute>', '', 'F'],
          ['<attribute-list>', '', 'F'],
          [';', 'T', 'F'],
        ],
        '<attribute-list>' => [
          ['<attribute>', '', 2],
          ['<attribute-list>', 'T', 2],
          ['<empty>', 'T', 'T']
        ],
        '<attribute>' => [
          ['INTEGER', 'T', 1],
          ['FLOAT', 'T', 2],
          ['[', '', 'F'],
          ['<range>', '', 'F'],
          [']', 'T', 'F']
        ],
        '<range>' => [
          ['<unsigned-integer>', '', 'F'],
          ['..', '', 'F'],
          ['<unsigned-integer>', 'T', 'F']
        ],
        '<statements-list>' => [
          ['<statement>', '', 2],
          ['<statements-list>', 'T', 'F'],
          ['<empty>', 'T', 'T']
        ],
        '<statement>' => [
          ['LOOP', '', 4],
          ['<statements-list>', '', 'F'],
          ['ENDLOOP', '', 'F'],
          [';', 'T', 'F'],
          ['<variable>', '', 'F'],
          [':=', '', 'F'],
          ['<expression>', '', 'F'],
          [';', 'T', 'F']
        ],
        '<expression>' => [
          ['<variable>', 'T', 1],
          ['<unsigned-integer>', 'T', 'F']
        ],
        '<variable>' => [
          ['<variable-identifier>', '', 'F'],
          ['<dimension>', 'T', 'F']
        ],
        '<dimension>' => [
          ['[', '', 3],
          ['<expression>', '', 'F'],
          [']', 'T', 'F'],
          ['<empty>', 'T', 'T']
        ],
        '<variable-identifier>' => [['<identifier>', 'T', 'F']],
        '<procedure-identifier>' => [['<identifier>', 'T', 'F']],
        '<start>' => [
          ['<signal-program>', '', 'ERROR'],
          ['#', 'OK', 'ERROR']
        ]
      }
    end
  end
end