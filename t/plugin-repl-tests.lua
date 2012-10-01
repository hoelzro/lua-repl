local r = require 'repl' -- we don't call it 'repl' so we don't shadow
                         -- repl in the plugin environment
pcall(require, 'luarocks.loader')
require 'Test.More'
local utils = require 'test-utils'

plan(3)

local clone = r:clone()

do -- basic tests {{{
  local with_plugin = clone:clone()

  function with_plugin:foo()
  end

  local line_no

  local _, err = pcall(function()
    with_plugin:loadplugin(function()
      line_no = utils.next_line_number()
      function repl:foo()
      end
    end)
  end)

  like(err, string.format("%d: The 'foo' method already exists", line_no))

  with_plugin:loadplugin(function()
    function repl:bar()
      return 17
    end
  end)

  is(with_plugin:bar(), 17)

  with_plugin:loadplugin(function()
    repl.baz = 18
  end)

  is(with_plugin.baz, 18)
end -- }}}
