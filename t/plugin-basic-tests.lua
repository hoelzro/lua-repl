local repl  = require 'repl'
local utils = require 'test-utils'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(21)

local clone = repl:clone()

do -- basic tests {{{
  local loaded

  clone:loadplugin(function()
    loaded = true
  end)

  ok(loaded)

  error_like(function()
    clone:loadplugin(function()
      error 'uh-oh'
    end)
  end, 'uh%-oh')

end -- }}}

do -- loading the same plugin twice {{{
  local function plugin()
  end

  local line_no

  clone:loadplugin(plugin)
  local _, err = pcall(function()
    line_no = utils.next_line_number()
    clone:loadplugin(plugin)
  end)
  like(err, tostring(line_no) .. ': plugin "function:%s+%S+" has already been loaded')

  _, err = pcall(function()
    line_no = utils.next_line_number()
    clone:clone():loadplugin(plugin)
  end)
  like(err, tostring(line_no) .. ': plugin "function:%s+%S+" has already been loaded')

  repl:clone():loadplugin(plugin)
  repl:clone():loadplugin(plugin)
end -- }}}

do -- loading plugins by name {{{
  local loaded

  package.preload['repl.plugins.test'] = function()
    loaded = true
  end

  clone:clone():loadplugin 'test'

  ok(loaded)
  loaded = false

  clone:clone():loadplugin 'test'

  ok(loaded, 'loading a plugin twice should initialize it twice')

  package.preload['repl.plugins.test'] = function()
    error 'uh-oh'
  end

  error_like(function()
    clone:clone():loadplugin 'test'
  end, 'uh%-oh')

  package.preload['repl.plugins.test'] = nil

  local line_no

  local _, err = pcall(function()
    line_no = utils.next_line_number()
    clone:clone():loadplugin 'test'
  end)
  like(err, tostring(line_no) .. ': unable to locate plugin')
end -- }}}

do -- hasplugin tests {{{
  local child = repl:clone()

  local plugin = function()
  end

  child:loadplugin(plugin)

  local grandchild = child:clone()

  ok(not repl:hasplugin(plugin))
  ok(child:hasplugin(plugin))
  ok(grandchild:hasplugin(plugin))

  plugin = function()
  end

  child:loadplugin(plugin)

  ok(not repl:hasplugin(plugin))
  ok(child:hasplugin(plugin))
  ok(not grandchild:hasplugin(plugin))
end -- }}}

do -- global tests {{{
  local clone = repl:clone()
  local line_no

  local _, err = pcall(function()
    clone:loadplugin(function()
      line_no = utils.next_line_number()
      foo     = 17
    end)
  end)

  like(err, tostring(line_no) .. ': global environment is read%-only %(key = "foo"%)')

  _, err = pcall(function()
    clone:loadplugin(function()
      line_no = utils.next_line_number()
      _G.foo  = 17
    end)
  end)

  like(err, tostring(line_no) .. ': global environment is read%-only %(key = "foo"%)')
end

do -- ifplugin tests {{{
  local clone = repl:clone()
  local has_run

  package.preload['repl.plugins.test'] = function()
  end

  clone:ifplugin('test', function()
    has_run = true
  end)

  ok(not has_run)

  clone:loadplugin 'test'

  ok(has_run)

  has_run = false

  clone:ifplugin('test', function()
    has_run = true
  end)

  ok(has_run)
end -- }}}

do -- ifplugin multiple times {{{
  local clone = repl:clone()
  local has_run
  local has_run2

  package.preload['repl.plugins.test'] = function()
  end

  clone:ifplugin('test', function()
    has_run = true
  end)

  clone:ifplugin('test', function()
    has_run2 = true
  end)

  clone:loadplugin 'test'

  ok(has_run)
  ok(has_run2)
end -- }}}
