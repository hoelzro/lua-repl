package = 'luarepl'
version = '0.3-1'
source  = {
    url = 'https://github.com/downloads/hoelzro/lua-repl/lua-repl-0.3.tar.gz'
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
    ['repl']                        = 'repl/init.lua',
    ['repl.sync']                   = 'repl/sync.lua',
    ['repl.console']                = 'repl/console.lua',
    ['repl.plugins.autoreturn']     = 'repl/plugins/autoreturn.lua',
    ['repl.plugins.completion']     = 'repl/plugins/completion.lua',
    ['repl.plugins.example']        = 'repl/plugins/example.lua',
    ['repl.plugins.history']        = 'repl/plugins/history.lua',
    ['repl.plugins.keep_last_eval'] = 'repl/plugins/keep_last_eval.lua',
    ['repl.plugins.linenoise']      = 'repl/plugins/linenoise.lua',
    ['repl.plugins.pretty_print']   = 'repl/plugins/pretty_print.lua',
    ['repl.plugins.rcfile']         = 'repl/plugins/rcfile.lua',
  },
  install = {
      bin = { 'rep.lua' },
  }
}
