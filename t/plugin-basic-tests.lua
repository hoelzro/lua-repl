local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(1)

local clone = repl:clone()

do -- init() tests
  local loaded

  clone:loadplugin(function()
    function init()
      loaded = true
    end
  end)

  ok(loaded)
  -- XXX error out
  -- XXX parameters passed to init()
end
