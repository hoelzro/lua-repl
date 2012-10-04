local repl = require 'repl'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(6)

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
