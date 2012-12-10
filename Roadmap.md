0.4
===

  * Run Lua scripts with rep.lua (done, may remove)
  * Process Lua command line options with rep.lua
  * Verify that it works with LuaJIT, Lua 5.0, Lua 5.2, LuaJ or something
  * Asynchronous example (GTK+?)
  * \_\_pretty support for pretty print plugin
  * \_\_complete support for completion plugin
  * Rename rep.lua to something more easily typable
  * Documentation changes
    * Clearly reference PLUGINS.md from README.md
    * Clearly reference rep.lua (or whatever I call it in the future) from README.md
    * Make sure documentation on ~/.rep.lua is clear
    * Move docs into doc/
    * Make sure we talk up autocompletion in plugins.md (and mention in readme.md that many default/optional behaviors are present there)

Future
======

  * Plugins
    * where do plugins store values (self, storage object, etc?)
    * configuration
    * global assignments in plugins
    * we need a way to do method advice in REPL "subclasses"
    * test: iffeature
    * test: using advice from within ifplugin/iffeature
    * luaish plugin
  * Steal ideas from ilua
    * Variables in ilua must be declared before use
    * -L is like -l, except it automatically brings it into the global NS
    * require() wrapper that does this ↑
    * table display logic control, float precision control
    * print\_handler (custom print logic for types)
      * \_\_pretty
    * global\_handler (custom lookup logic to complement strict mode)
      * easily done via a plugin
    * line\_handler (custom handling of lines before being processed)
  * Steal ideas from luaish
    * Shell commands (lines beginning with ., filename completion)
  * Steal ideas from http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print\_loop
  * Steal ideas from pry, ipython, bpython, Devel::REPL, Factor REPL
  * Steal ideas from https://github.com/tpope/vim-foreplay
  * Async implementation
  * GTK implementation
  * IRC bot implementation
  * Awesome library
