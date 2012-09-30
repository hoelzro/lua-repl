local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(2)

local clone = repl:clone()

do -- init() tests
  local loaded

  clone:loadplugin(function()
    function init()
      loaded = true
    end
  end)

  ok(loaded)

  error_like(function()
    clone:loadplugin(function()
      function init()
        error 'uh-oh'
      end
    end)
  end, 'uh%-oh')
  -- XXX parameters passed to init()
end
