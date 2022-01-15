package = 'luarepl'
version = '0.10-1'
source  = {
    url = 'https://github.com/hoelzro/lua-repl/archive/0.10.tar.gz',
    dir = 'lua-repl-0.10',
}
description = {
  summary  = 'A reusable REPL component for Lua, written in Lua',
  homepage = 'https://github.com/hoelzro/lua-repl',
  license  = 'MIT/X11',
}
dependencies = {
  'lua >= 5.1'
}
build = {
  type = 'builtin',
  modules = {
    ['repl']                                   = 'repl/init.lua',
    ['repl.utils']                             = 'repl/utils.lua',
    ['repl.sync']                              = 'repl/sync.lua',
    ['repl.compat']                            = 'repl/compat.lua',
    ['repl.console']                           = 'repl/console.lua',
    ['repl.plugins.autoreturn']                = 'repl/plugins/autoreturn.lua',
    ['repl.plugins.completion']                = 'repl/plugins/completion.lua',
    ['repl.plugins.example']                   = 'repl/plugins/example.lua',
    ['repl.plugins.history']                   = 'repl/plugins/history.lua',
    ['repl.plugins.keep_last_eval']            = 'repl/plugins/keep_last_eval.lua',
    ['repl.plugins.linenoise']                 = 'repl/plugins/linenoise.lua',
    ['repl.plugins.pretty_print']              = 'repl/plugins/pretty_print.lua',
    ['repl.plugins.rcfile']                    = 'repl/plugins/rcfile.lua',
    ['repl.plugins.semicolon_suppress_output'] = 'repl/plugins/semicolon_suppress_output.lua',
    ['repl.plugins.filename_completion']       = 'repl/plugins/filename_completion.lua',
    ['repl.plugins.rlwrap']                    = 'repl/plugins/rlwrap.lua',
  },
  install = {
      bin = { 'rep.lua' },
  }
}
