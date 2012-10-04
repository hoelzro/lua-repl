local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(2)

local clone = repl:clone()

do -- basic tests {{{
  local loaded

  clone:loadplugin(function()
    loaded = true
  end)

  ok(loaded)

  error_like(function()
    clone:loadplugin(function()
      error 'uh-oh'
    end)
  end, 'uh%-oh')
end -- }}}
