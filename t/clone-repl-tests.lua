-- vim:foldmethod=marker
local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(45)

local clone = repl:clone()
local prompt
local results
local errmsg

isnt(type(clone), 'nil')

function clone:showprompt(p)
  prompt = p
end

function clone:displayresults(r)
  results = r
end

function clone:displayerror(err)
  errmsg = err
end

do -- prompt tests
  lives_ok(function()
    clone:prompt(1)
  end)

  is(prompt, '>')

  lives_ok(function()
    clone:prompt(2)
  end)

  is(prompt, '>>')
end

do -- handleline tests
  is(_G.testresult, nil)
  is(results, nil)

  lives_ok(function()
    clone:handleline '_G.testresult = 18'
  end)

  is(_G.testresult, 18)

  is(type(results), 'table')
  is(results.n, 0)
  is(#results, 0)

  lives_ok(function()
    clone:handleline 'return 19'
  end)

  is(type(results), 'table')
  is(results.n, 1)
  is(#results, 1)
  is(results[1], 19)

  lives_ok(function()
    clone:handleline 'return 20, 21, 22'
  end)

  is(type(results), 'table')
  is(results.n, 3)
  is(#results, 3)
  is(results[1], 20)
  is(results[2], 21)
  is(results[3], 22)

  lives_ok(function()
    clone:handleline 'return 1, nil, nil, nil, nil, nil, nil, 2'
  end)

  is(type(results), 'table')
  is(results.n, 8)
  is(results[1], 1)
  for i = 2, 7 do
    is(results[i], nil)
  end
  is(results[8], 2)
end

do -- error handling tests
  lives_ok(function()
    clone:handleline '3 4'
  end)

  isnt(type(errmsg), 'nil')

  errmsg = nil

  lives_ok(function()
    clone:handleline 'error "foo"'
  end)

  like(errmsg, 'foo')
end

do -- multi-line input tests
  errmsg = nil
  _G.t = {}

  lives_ok(function()
    clone:handleline 'for i = 1, 3 do'
    clone:handleline '  table.insert(_G.t, i)'
    clone:handleline 'end'
  end)

  is(errmsg, nil)
  is(#_G.t, 3)
  is(_G.t[1], 1)
  is(_G.t[2], 2)
  is(_G.t[3], 3)
end
