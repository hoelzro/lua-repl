local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(19)

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
end

do -- before tests (arguments)
  local with_plugin = clone:clone()
  local got_args

  function with_plugin:foo()
  end

  with_plugin:loadplugin(function()
    function before:foo(...)
      got_args = {
        n = select('#', ...),
        ...,
      }
    end
  end)

  with_plugin:foo()
  is(got_args.n, 0)

  with_plugin:foo(1, 2, 3)
  is(got_args.n, 3)
  is(got_args[1], 1)
  is(got_args[2], 2)
  is(got_args[3], 3)

  with_plugin:foo(1, nil, nil, nil, 5)
  is(got_args.n, 5)
  is(got_args[1], 1)
  is(got_args[2], nil)
  is(got_args[3], nil)
  is(got_args[4], nil)
  is(got_args[5], 5)
end

do -- before tests (exception)
  local with_plugin = clone:clone()

  local has_called_original

  function with_plugin:foo()
    has_called_original = true
  end

  with_plugin:loadplugin(function()
    function before:foo()
      error 'uh-oh'
    end
  end)

  local _, err = pcall(with_plugin.foo, with_plugin)

  like(err, 'uh%-oh')
  ok(not has_called_original)
end
