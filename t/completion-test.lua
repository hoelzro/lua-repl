local complete = require 'repl.util.completions'
require 'Test.More'

local sfind   = string.find
local sformat = string.format
local tsort   = table.sort

local function test_completions(line, expected)
  local got = {}

  if type(expected) == 'string' then
    expected = { expected }
  end

  complete(line, function(completion)
    got[#got + 1] = completion
  end)

  -- don't sort got; we expect it to be sorted!
  tsort(expected)

  if #got ~= #expected then
    fail 'result count mismatch'
    diag('     got: ' .. tostring(#got))
    diag('expected: ' .. tostring(#expected))
  else
    for i = 1, #got do
      local got_v      = got[i]
      local expected_v = expected[i]

      if got_v ~= expected_v then
        fail 'result mismatch'
        diag(sformat('     got[%d]: %q', i, got_v))
        diag(sformat('expected[%d]: %q', i, expected_v))
        return
      end
    end

    pass()
  end
end

local function filter(table, pattern)
  local result = {}

  for _, s in ipairs(table) do
    if sfind(s, pattern) then
      result[#result + 1] = s
    end
  end

  return result
end

local function collect_annotated_keys(table, prefix)
  local keys = {}

  prefix = prefix or ''

  for k, v in pairs(table) do
    local type = type(v)

    if type == 'function' then
      k = k .. '('
    elseif type == 'table' then
      k = k .. '.'
    end

    keys[#keys + 1] = prefix .. k
  end

  return keys
end

plan(12)

special_object               = {}
local special_object_methods = {
  'foo',
  'bar',
  'baz',
}

setmetatable(special_object, { __index = function()
  -- in the real world, this would actually do something
end, __complete = function()
  -- XXX implement me
end})

local global_keys     = collect_annotated_keys(_G)
local io_keys         = collect_annotated_keys(io, 'io.')
local io_methods      = collect_annotated_keys(getmetatable(io.stdin).__index, 'io.stdin.')
local io_method_calls = collect_annotated_keys(getmetatable(io.stdin).__index, 'io.stdin:')

test_completions('', global_keys)
test_completions('co', filter(global_keys, '^co.*'))
test_completions('io.', io_keys)
test_completions('no_such_prefix', {})
test_completions('io.stdin', { 'io.stdin' })
test_completions('io.stdin.', io_methods)
test_completions('io.std', { 'io.stdin', 'io.stderr', 'io.stdout' })
test_completions('_G._G._G.', collect_annotated_keys(_G, '_G._G._G.'))
test_completions('io.stdin:', io_method_calls)
test_completions('print(co', filter(collect_annotated_keys(_G, 'print('), '^print%(co.*'))
test_completions('"foo " .. _V', '"foo " .. _VERSION')
test_completions('non.existent.', {})

-- XXX skip doesn't seem to work properly?
--skip('completing complex expressions is not yet implemented', 1)
--test_completions('_G._VERSION:sub(1, 3):le', collect_annotated_keys(string, '_G._VERSION:sub(1, 3):'))

--skip('__complete is not yet implemented', 1)
--test_completions('special_object.', special_object_methods)

--[[

-- XXX is this neccessary, since there is likely a single REPL?
local complete = require 'repl.util.complete' { ... }

]]
