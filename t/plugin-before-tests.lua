local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

local function next_line_number()
  local info = debug.getinfo(2, 'l')
  return info.currentline + 1 -- doesn't work with whitespace
end

local function cmp_tables(lhs, rhs)
  local ok = true
  local got
  local expected
  local failing_k

  for k, v in pairs(lhs) do
    local rv = rhs[k]

    if v ~= rv then
      ok        = false
      failing_k = k
      got       = v
      expected  = rv
      break
    end
  end

  if ok then
    for k, v in pairs(rhs) do
      local lv = lhs[k]

      if v ~= lv then
        ok        = false
        failing_k = k
        got       = lv
        expected  = v
        break
      end
    end
  end

  if ok then
    pass()
  else
    fail 'value mismatch'
    diag(string.format('     got[%q]: %s', tostring(failing_k), tostring(got)))
    diag(string.format('expected[%q]: %s', tostring(failing_k), tostring(expected)))
  end
end

local function gather_results(...)
  return {
    n = select('#', ...),
    ...,
  }
end

plan(24)

local clone = repl:clone()

do -- basic tests
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
end

do -- arguments tests
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
    function before:foo(...)
      got_args = {
        n = select('#', ...),
        ...,
      }
    end
  end)

  with_plugin:foo()
  is(got_args.n, 0)
  cmp_tables(orig_args, got_args)

  with_plugin:foo(1, 2, 3)
  is(got_args.n, 3)
  is(got_args[1], 1)
  is(got_args[2], 2)
  is(got_args[3], 3)
  cmp_tables(orig_args, got_args)

  with_plugin:foo(1, nil, nil, nil, 5)
  is(got_args.n, 5)
  is(got_args[1], 1)
  is(got_args[2], nil)
  is(got_args[3], nil)
  is(got_args[4], nil)
  is(got_args[5], 5)
  cmp_tables(orig_args, got_args)
end

do -- exception tests
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

do -- return value tests
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
    function before:foo()
      return 18
    end

    function before:bar()
      return 18
    end

    function before:baz()
    end
  end)

  local result = with_plugin:foo()
  is(result, 17)

  local results = gather_results(with_plugin:bar())
  cmp_tables(results, { n = 3, 18, 19, 20 })

  results = gather_results(with_plugin:baz())
  cmp_tables(results, { n = 5, 1, nil, nil, nil, 5 })
end
