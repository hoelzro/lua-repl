package = 'luarepl'
version = '0.2-1'
source  = {
    url = 'https://github.com/downloads/hoelzro/lua-repl/lua-repl-0.2.tar.gz'
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
    ['repl']                  = 'repl/init.lua',
    ['repl.sync']             = 'repl/sync.lua',
    ['repl.console']          = 'repl/console.lua',
    ['repl.linenoise']        = 'repl/linenoise.lua',
    ['repl.util.completions'] = 'repl/util/completions.lua',
  },
  install = {
      bin = { 'rep.lua' },
  }
}
