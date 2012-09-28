-- Copyright (c) 2011-2012 Rob Hoelz <rob@hoelz.ro>
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

local ln             = require 'linenoise'
local console        = require 'repl.console'
local complete       = require 'repl.util.completions'
local linenoise_repl = console:clone()

-- @class repl.linenoise
--- This module implements a command line-based REPL that
--- offers advanced features like history and tab completion.
--- This module also supports REPL history; the history is
--- stored in $HOME/.rep.lua.history.

local history_file

if os.getenv 'HOME' then
  history_file = os.getenv('HOME') .. '/.rep.lua.history'
end

if history_file then
  ln.historyload(history_file)
end

ln.setcompletion(function(completions, line)
  complete(line, function(completion)
    ln.addcompletion(completions, completion)
  end)
end)

function linenoise_repl:showprompt(prompt)
  self._prompt = prompt
end

function linenoise_repl:lines()
  return function()
    local line = ln.linenoise(self._prompt .. ' ')

    if line then
      ln.historyadd(line)
    else -- XXX dodgy way to find out when we're exiting
      if history_file then
        ln.historysave(history_file)
      end
    end

    return line
  end
end

return linenoise_repl
