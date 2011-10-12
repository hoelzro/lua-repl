-- Copyright (c) 2011 Rob Hoelz <rob@hoelz.ro>
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

local repl         = {}
local select       = select
local loadstring   = loadstring
local dtraceback   = debug.traceback
local setmetatable = setmetatable
local smatch       = string.match

-- @class repl
--- This module implements the core functionality of a REPL.

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
-- @see xpcall
function repl:traceback(...)
  return dtraceback(...)
end

function repl:detectcontinue(err)
  return smatch(err, "'<eof>'$")
end

function repl:evaluate(line)
  local chunk  = self._buffer .. line
  local f, err = loadstring('return ' .. chunk, self:name())

  if not f then
    f, err = loadstring(chunk, self:name())
  end

  if f then
    self._buffer = ''

    local success, results = gather_results(xpcall(f, function(...) self:traceback(...) end))
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

function repl:clone()
  return setmetatable({ _buffer = '' }, { __index = self })
end

return repl
