local lfs = require 'lfs'
assert(lfs, 'LuaFileSystem is missing.')

--features = 'completion'
--[[
Completion suggestions should only span the part of the line which is actually completed.

While the current implementation is good enough for linenoise completion,
imagine if some

This is no a problem per se, but it opens up the possibility to yield weird
completion results.  Though you can't display the suggestion in a popup, so the
user sees all available suggestions at a glance.
 ]]

repl:requirefeature 'completion'

local function guess_directory_separator(file_name)
  return file_name:match('/') or
         file_name:match('\\\\') or
         '/'
end

local function split_parent_directory(file_name)
  local parent_directory, direcotry_entry file_name:match('^(.+)(\\-[\\/].+)$')
  if not parent_directory then
    parent_directory = '.'
    direcotry_entry = file_name
  end
  return parent_directory, direcotry_entry
end

local function is_ignored_directory_entry(entry)
  return entry:find('^[\\/]%.$')
end

local function complete_file_name(file_name, expr, callback)
  local directory, entry = split_parent_directory(file_name)
  for entry in lfs.dir(directory) do
    if not is_ignored_directory_entry(entry) then
      callback(expr..entry)
    end
  end
end

local function complete_directory(directory, expr, callback)
  for entry in lfs.dir(directory) do
    if not is_ignored_directory_entry(entry) then
      callback(expr..entry)
    end
  end
end

function after:complete(expr, callback)
  local str = expr:match('[\'"](.-)$') -- TODO: String detection is suboptimal
  if str then
    local file_name = expr:match('[%w@/\\.-_+#$%%{}[%]!~ ]+$')
    if file_name then
      local file_mode = lfs.attributes(file_name, 'mode')
      if not file_mode then
        complete_file_name(file_name, expr, callback)
      elseif file_mode == 'directory' then -- TODO: what about directory links?
        complete_directory(file_name, expr, callback)
      end
    end
  end
end
