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

-- @class repl
--- This module implements the core functionality of a REPL.

local repl         = { _buffer = '' }
local select       = select
local loadstring   = loadstring
local dtraceback   = debug.traceback
local setmetatable = setmetatable
local smatch       = string.match
local error        = error

local function gather_results(success, ...)
  local n = select('#', ...)
  return success, { n = n, ... }
end

--- Returns the prompt for a given level.
-- @param level The prompt level. Either 1 or 2.
function repl:getprompt(level)
  return level == 1 and 'lua>' or 'lua>>'
end

--- Displays a prompt for the given prompt level.
-- @param level The prompt level. Either 1 or 2.
function repl:prompt(level)
  self:showprompt(self:getprompt(level))
end

--- Returns the name of the REPL.  For usage in chunk compilation.
-- @return The REPL's name.
-- @see load
function repl:name()
  return 'REPL'
end

--- Gets a traceback for an error.
-- @param ... All of the stuff that xpcall passes to error functions.
-- @see xpcall
-- @return A stack trace.  The default implementation returns a simple string-based trace.
function repl:traceback(...)
  return dtraceback(...)
end

--- Uses the compilation error to determine whether or not further input
--- is pending after the last line.  You shouldn't have to override this
--- unless you use an implementation of Lua that varies in its error
--- messages.
-- @param err The compilation error from Lua.
-- @return Whether or not the input should continue after this line.
function repl:detectcontinue(err)
  return smatch(err, "'<eof>'$")
end

--- Evaluates a line of input, and displays return value(s).
-- @param line The line to evaluate
-- @return The prompt level (1 or 2)
function repl:evaluate(line)
  local chunk  = self._buffer .. line
  local f, err = loadstring('return ' .. chunk, self:name())

  if not f then
    f, err = loadstring(chunk, self:name())
  end

  if f then
    self._buffer = ''

    local success, results = gather_results(xpcall(f, function(...) return self:traceback(...) end))
    if success then
      self:displayresults(results)
    else
      self:displayerror(results[1])
    end
  else
    if self:detectcontinue(err) then
      self._buffer = chunk .. '\n'
      return 2
    else
      self:displayerror(err)
    end
  end

  return 1
end

--- Creates a new REPL object, so you can override methods without fear.
-- @return A REPL clone.
function repl:clone()
  return setmetatable({ _buffer = '' }, { __index = self })
end

--- Displays the given prompt to the user.  Must be overriden.
-- @param prompt The prompt to display.
function repl:showprompt(prompt)
  error 'You must implement the showprompt method'
end

--- Displays the results from evaluate().  Must be overriden.
-- @param results The results to display. The results are a table, with the integer keys containing the results, and the 'n' key containing the highest integer key.

function repl:displayresults(results)
  error 'You must implement the displayresults method'
end

--- Displays errors from evaluate().  Must be overriden.
-- @param err The error value returned from repl:traceback().
-- @see repl:traceback
function repl:displayerror(err)
  error 'You must implement the displayerror method'
end

return repl
