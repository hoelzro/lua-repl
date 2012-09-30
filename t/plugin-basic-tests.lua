local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(6)

local function next_line_number()
  local info = debug.getinfo(2, 'l')
  return info.currentline + 1 -- doesn't work with whitespace
end

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

  local line_no

  local _, err = pcall(function()
    with_plugin:loadplugin(function()
      line_no = next_line_number()
      function before:nonexistent()
      end
    end)
  end)

  like(err, string.format("%d: The 'nonexistent' method does not exist", line_no))

  _, err = pcall(function()
    with_plugin:loadplugin(function()
      line_no = next_line_number()
      before.foo = 17
    end)
  end)

  like(err, string.format('%d: 17 is not a function', line_no))

  -- XXX verify that wrapped functions have their params/return values preserved
  -- XXX what parameters does the advice yet?
  -- XXX what happens if the advice throws an exception?
  -- XXX what is done with the advice's return value?
end
