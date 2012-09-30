local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(5)

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

do -- before tests
  local with_plugin = clone:clone()

  local has_called_normal
  local has_called_before

  function with_plugin:foo()
    has_called_normal = true
  end

  with_plugin:loadplugin(function()
    function before:foo()
      has_called_before = true
      ok(not has_called_normal)
    end
  end)

  with_plugin:foo()
  ok(has_called_normal)
  ok(has_called_before)

  error_like(function()
    with_plugin:loadplugin(function()
      function before:nonexistent()
      end
    end)
  end, "The 'nonexistent' method does not exist") -- XXX check line number?

  -- XXX test before.foo = nonfunction
  -- XXX verify that wrapped functions have their params/return values preserved
  -- XXX what parameters does the advice yet?
  -- XXX what happens if the advice throws an exception?
  -- XXX what is done with the advice's return value?
end
