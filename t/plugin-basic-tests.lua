local repl  = require 'repl'
local utils = require 'test-utils'
pcall(require, 'luarocks.loader')
require 'Test.More'

plan(4)

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
