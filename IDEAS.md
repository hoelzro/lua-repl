  * plugins
    * replace /^=/ with 'return'
    * handle locals
    * override debug.debug
    * supple (http://cgit.gitano.org.uk/supple.git)
  * handle locals (debug.sethook?)
    * debug.sethook, catch return of our chunk and grab its locals
    * rewrite source code/bytecode before evaluation
    * custom interpreter patch to "pcall and get bindings"
    * custom module that dips into internals to "pcall and get bindings"
  * some sort of debugger?
  * don't contaminate globals
  * tab completion (\_\_complete metamethod)
    * "safe" evaluation (don't allow calling of C functions, except for those in a whitelist?)
  * displaystack instead of displayerror(err)? (should xpcall return false, stack\_table?)
  * visual REPL (like Factor; being able to print multi-colored/multi-sized text, images, etc)
  * syntax highlighting
  * paren/brace matching?
  * snippets?
  * code navigation (go to definition?)
  * repls that "attach" to different objects (ie. inspect a single object; self is that object.  completions happen against that object?)
  * browsable/searchable REPL history
    * not entirely sure what I mean here...
  * safe termination of evaluated code (if I Control-C during an evaluation)
  * store stdout/stderr output in a variable somewhere?
  * persistence (pluto-based image)

hooks
=====

  * what to do when we encounter an incomplete Lua fragment
  * processing a line
  * something for debug.debug...

Implementations
===============

  * Console
  * GUI
  * Web
  * IRC
    * safety hooks
  * Awesome
