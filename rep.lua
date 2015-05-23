#!/usr/bin/env lua

-- Copyright (c) 2011-2015 Rob Hoelz <rob@hoelz.ro>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Not as cool a name as re.pl, but I tried.

local repl          = require 'repl.console'
local has_linenoise = pcall(require, 'linenoise')

if has_linenoise then
  repl:loadplugin 'linenoise'
else
  pcall(repl.loadplugin, repl, 'rlwrap')
end

repl:loadplugin 'history'
repl:loadplugin 'completion'
repl:loadplugin 'autoreturn'
local rcfile_loaded = repl:loadplugin 'rcfile'

if rcfile_loaded and not repl.quiet_default_plugins then
  print([[In Lua REPL 0.8, the default plugins will not be loaded if you have an
rcfile at ~/.rep.lua.  Please see the README for tips on handling this and
quieting this error message.]] .. '\n')
end

print('Lua REPL ' .. tostring(repl.VERSION))
repl:run()
