local sync = require 'repl.sync'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(13)

local clone      = sync:clone()
local resultlist = {}

function clone:lines()
  local index = 0
  local function iterator(s)
    index = index + 1
    return s[index]
  end

  return iterator, {
    'foo',
    '1',
    '"bar"',
    '{}',
    '1, 2, 3',
  }
end

function clone:showprompt()
end

function clone:displayresults(results)
  resultlist[#resultlist + 1] = results
end

clone:run()

is(#resultlist, 5)
is(resultlist[1].n, 1)
is(resultlist[1][1], nil)

is(resultlist[2].n, 1)
is(resultlist[2][1], 1)

is(resultlist[3].n, 1)
is(resultlist[3][1], 'bar')

is(resultlist[4].n, 1)
is(type(resultlist[4][1]), 'table')

is(resultlist[5].n, 3)
is(resultlist[5][1], 1)
is(resultlist[5][2], 2)
is(resultlist[5][3], 3)
