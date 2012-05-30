  * rc file
  * plugins
    * auto-return
    * replace /^=/ with 'return'
    * handle locals
    * override debug.debug
    * save old results
    * pretty print results
    * tab completion
  * handle locals (debug.sethook?)
    * debug.sethook, catch return of our chunk and grab its locals
    * rewrite source code/bytecode before evaluation
    * custom interpreter patch to "pcall and get bindings"
    * custom module that dips into internals to "pcall and get bindings"
  * some sort of debugger?
  * override debug.debug?
  * save old results (ala Python's \_)
  * pretty print results (like Data::Dumper)
  * don't contaminate globals
  * editline
  * tab completion (\_\_complete metamethod)
    * "safe" evaluation (don't allow calling of C functions, except for those in a whitelist?)
  * web-based REPL implementation
  * irc-based REPL implementation
    * safety hooks
  * displaystack instead of displayerror(err)? (should xpcall return false, stack\_table?)
  * visual REPL (like Factor; being able to print multi-colored/multi-sized text, images, etc)
  * syntax highlighting
  * paren/brace matching?
  * snippets?
  * code navigation (go to definition?)
  * history
  * repls that "attach" to different objects (ie. inspect a single object; self is that object.  completions happen against that object?)
  * browsable/searchable REPL history
  * safe termination of evaluated code (if I Control-C during an evaluation)
  * store stdout/stderr output in a variable somewhere?

hooks
=====

  * what to do when we encounter an incomplete Lua fragment
  * processing a line
  * something for debug.debug...
