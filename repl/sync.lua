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

local repl      = require 'repl'
local sync_repl = repl:clone()
local error     = error

--- This module implements a synchronous REPL.  It provides
-- a run() method for actually running the REPL, and requires
-- that implementors implement the lines() method.
-- @classmod repl.sync
-- @alias sync_repl

--- Run a REPL loop in a synchronous fashion.
function sync_repl:run()
  self:prompt(1)
  for line in self:lines() do
    local level = self:handleline(line)
    self:prompt(level)
  end
  self:shutdown()
end

--- Returns an iterator that yields lines to be evaluated.
-- @return An iterator.
function sync_repl:lines()
  error 'You must implement the lines method'
end

return sync_repl
