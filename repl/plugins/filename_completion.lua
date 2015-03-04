local lfs = require 'lfs'
assert(lfs, 'LuaFileSystem is missing.')

repl:requirefeature 'completion'

local function guess_directory_separator(file_name)
  return file_name:match('/') or
         file_name:match('\\') or
         '/'
end

local function split_parent_directory(file_name)
  local parent_directory, directory_entry =
    file_name:match('^(.+)[\\/](.+)$')
  if not parent_directory then
    parent_directory = '.'
    directory_entry = file_name
  end
  return parent_directory, directory_entry
end

local function is_ignored_directory_entry(entry)
  return entry == '.'
end

local function replace_end_of_string(str, suffix, replacement)
  assert(str:sub(-#suffix) == suffix)
  return str:sub(1, -(#suffix+1)) .. replacement
end

local function complete_file_name(file_name, expr, callback)
  local directory, partial_entry = split_parent_directory(file_name)
  print('\n', partial_entry)
  for entry in lfs.dir(directory) do
    if not is_ignored_directory_entry(entry) and
       entry:find(partial_entry, 1, true) == 1 then
      callback(replace_end_of_string(expr, partial_entry, entry))
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
      if file_name:find('[/\\]$') then
        complete_directory(file_name, expr, callback)
      else
        complete_file_name(file_name, expr, callback)
      end
    end
  end
end
