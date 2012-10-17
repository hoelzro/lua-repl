local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'
local utils = require 'test-utils'

plan(27)

local clone = repl:clone()

do -- basic tests {{{
  local with_plugin = clone:clone()

  local has_called_normal
  local has_called_around

  function with_plugin:foo()
    has_called_normal = true
  end

  with_plugin:loadplugin(function()
    function around:foo(orig, ...)
      has_called_around = true
      ok(not has_called_normal)
      local return_values = utils.gather_results(orig(self, ...))
      ok(has_called_normal)
      return unpack(return_values, 1, return_values.n)
    end
  end)

  with_plugin:foo()
  ok(has_called_normal)
  ok(has_called_around)

  local line_no

  local _, err = pcall(function()
    with_plugin:loadplugin(function()
      line_no = utils.next_line_number()
      function around:nonexistent()
      end
    end)
  end)

  like(err, string.format("%d: The 'nonexistent' method does not exist", line_no))

  _, err = pcall(function()
    with_plugin:loadplugin(function()
      line_no = utils.next_line_number()
      around.foo = 17
    end)
  end)

  like(err, string.format('%d: 17 is not a function', line_no))
end -- }}}

do -- arguments tests {{{
  local with_plugin = clone:clone()
  local orig_args
  local got_args

  function with_plugin:foo(...)
    orig_args = {
      n = select('#', ...),
      ...,
    }
  end

  with_plugin:loadplugin(function()
    function around:foo(orig, ...)
      got_args = {
        n = select('#', ...),
        ...,
      }

      return orig(self, ...)
    end
  end)

  with_plugin:foo()
  is(got_args.n, 0)
  utils.cmp_tables(orig_args, got_args)

  with_plugin:foo(1, 2, 3)
  is(got_args.n, 3)
  is(got_args[1], 1)
  is(got_args[2], 2)
  is(got_args[3], 3)
  utils.cmp_tables(orig_args, got_args)

  with_plugin:foo(1, nil, nil, nil, 5)
  is(got_args.n, 5)
  is(got_args[1], 1)
  is(got_args[2], nil)
  is(got_args[3], nil)
  is(got_args[4], nil)
  is(got_args[5], 5)
  utils.cmp_tables(orig_args, got_args)
end -- }}}

do -- exception tests {{{
  local with_plugin = clone:clone()

  local has_called_original

  function with_plugin:foo()
    has_called_original = true
  end

  with_plugin:loadplugin(function()
    function around:foo()
      error 'uh-oh'
    end
  end)

  local _, err = pcall(with_plugin.foo, with_plugin)

  like(err, 'uh%-oh')
  ok(not has_called_original)
end -- }}}

do -- return value tests {{{
  local with_plugin = clone:clone()

  function with_plugin:foo()
    return 17
  end

  function with_plugin:bar()
    return 18, 19, 20
  end

  function with_plugin:baz()
    return 1, nil, nil, nil, 5
  end

  with_plugin:loadplugin(function()
    function around:foo()
      return 18
    end

    function around:bar()
      return 19, 20, 21
    end

    function around:baz()
      return 1, nil, nil, 4
    end
  end)

  local result = with_plugin:foo()
  is(result, 18)

  local results = utils.gather_results(with_plugin:bar())
  utils.cmp_tables(results, { n = 3, 19, 20, 21 })

  results = utils.gather_results(with_plugin:baz())
  utils.cmp_tables(results, { n = 4, 1, nil, nil, 4 })
end -- }}}

do -- multiple advice, multiple plugins {{{
  local with_plugin = clone:clone()
  local calls       = {}

  function with_plugin:foo()
    calls[#calls + 1] = 'original'
  end

  with_plugin:loadplugin(function()
    function around:foo(orig)
      calls[#calls + 1] = 'before_one'
      orig()
      calls[#calls + 1] = 'after_one'
    end
  end)

  with_plugin:loadplugin(function()
    function around:foo(orig)
      calls[#calls + 1] = 'before_two'
      orig()
      calls[#calls + 1] = 'after_two'
    end
  end)

  with_plugin:foo()

  utils.cmp_tables(calls, { 'before_two', 'before_one', 'original',
    'after_one', 'after_two' })
end -- }}}

do -- multiple advice, single plugin {{{
  local with_plugin = clone:clone()
  local calls       = {}

  function with_plugin:foo()
    calls[#calls + 1] = 'original'
  end

  with_plugin:loadplugin(function()
    function around:foo(orig)
      calls[#calls + 1] = 'before_one'
      orig()
      calls[#calls + 1] = 'after_one'
    end

    function around:foo(orig)
      calls[#calls + 1] = 'before_two'
      orig()
      calls[#calls + 1] = 'after_two'
    end
  end)

  with_plugin:foo()

  utils.cmp_tables(calls, { 'before_two', 'before_one', 'original',
    'after_one', 'after_two' })
end -- }}}
