local repl  = require 'repl'
local utils = require 'test-utils'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(7)

do -- basic tests {{{
  local clone = repl:clone()

  clone:loadplugin(function()
    features = 'foo'
  end)

  ok(clone:hasfeature 'foo')
  ok(not clone:hasfeature 'bar')
  ok(not clone:hasfeature 'baz')

  clone:loadplugin(function()
    features = { 'bar', 'baz' }
  end)

  ok(clone:hasfeature 'foo')
  ok(clone:hasfeature 'bar')
  ok(clone:hasfeature 'baz')
end -- }}}

do -- requirefeature {{{
  local clone = repl:clone()

  clone:loadplugin(function()
    features = 'foo'
  end)

  clone:requirefeature 'foo'

  local line_no
  local _, err = pcall(function()
    line_no = utils.next_line_number()
    clone:requirefeature 'bar'
  end)

  like(err, tostring(line_no) .. ': required feature "bar" not present')
end -- }}}
