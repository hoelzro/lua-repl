# REPL.lua - a reusable Lua REPL written in Lua

Many software projects have made the choice to embed Lua in their projects to
allow their users some extra flexibility.  Some of these projects would also
like to provide a Lua REPL in their programs for debugging or rapid development.
Most Lua programmers are familiar with the standalone Lua interpreter as a Lua REPL;
however, it is bound to the command line.  Until now, Lua programmers would have to
implement their own REPL from scratch if they wanted to include one in their programs.
This project aims to provide a REPL implemented in pure Lua that almost any project can
make use of.

# Project Goals

  * Provide REPL logic to Lua programs that include this module.

  * Be extensible through polymorphism and plugins.

  * Abstract away I/O, so you can run this REPL on the command line or in your own event loop and expect the same behavior.
