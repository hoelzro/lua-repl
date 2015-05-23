-- vim:foldmethod=marker
local repl  = require 'repl'
local utils = require 'test-utils'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(19)

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

do -- conflicts {{{
  local clone = repl:clone()
  local line_no

  clone:loadplugin(function()
    features = 'foo'
  end)

  local _, err = pcall(function()
    line_no = utils.next_line_number()
    clone:loadplugin(function()
      features = 'foo'
    end)
  end)
  like(err, tostring(line_no) .. ': feature "foo" already present')

  -- XXX what about methods injected into the object?
end -- }}}

do -- clone:hasfeature {{{
  local child = repl:clone()

  child:loadplugin(function()
    features = 'foo'
  end)

  local grandchild = child:clone()

  ok(not repl:hasfeature 'foo')
  ok(child:hasfeature 'foo')
  ok(grandchild:hasfeature 'foo')

  child:loadplugin(function()
    features = 'bar'
  end)

  ok(not repl:hasfeature 'bar')
  ok(child:hasfeature 'bar')
  ok(not grandchild:hasfeature 'bar')
end -- }}}

do -- iffeature tests {{{
  local clone = repl:clone()
  local has_run

  clone:iffeature('foo', function()
    has_run = true
  end)

  ok(not has_run)

  clone:loadplugin(function()
    features = 'foo'
  end)

  ok(has_run)

  has_run = false

  clone:iffeature('foo', function()
    has_run = true
  end)

  ok(has_run)
end -- }}}

do -- iffeature multiple times {{{
  local clone = repl:clone()
  local has_run
  local has_run2

  clone:iffeature('foo', function()
    has_run = true
  end)

  clone:iffeature('foo', function()
    has_run2 = true
  end)

  clone:loadplugin(function()
    features = 'foo'
  end)

  ok(has_run)
  ok(has_run2)
end -- }}}
