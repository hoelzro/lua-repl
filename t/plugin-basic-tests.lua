local repl  = require 'repl'
local utils = require 'test-utils'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(8)

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
