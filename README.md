# REPL.lua - a reusable Lua REPL written in Lua, and an alternative to /usr/bin/lua

This project has two uses:

  - An alternative to the standalone interpreter included with Lua, one that supports
    things like plugins, tab completion, and automatic insertion of `return` in front
    of expression.

  - A REPL library you may embed in your application, to provide all of the niceties
    of the standalone interpreter included with Lua and then some.

Many software projects have made the choice to embed Lua in their projects to
allow their users some extra flexibility.  Some of these projects would also
like to provide a Lua REPL in their programs for debugging or rapid development.
Most Lua programmers are familiar with the standalone Lua interpreter as a Lua REPL;
however, it is bound to the command line.  Until now, Lua programmers would have to
implement their own REPL from scratch if they wanted to include one in their programs.
This project aims to provide a REPL implemented in pure Lua that almost any project can
make use of.

This library also includes an example application (rep.lua), which serves as an alternative
to the standalone interpreter included with Lua.  If the lua-linenoise library is installed,
it uses linenoise for history and tab completion; otherwise, it tries to use rlwrap for
basic line editing.

# Project Goals

  * Provide REPL logic to Lua programs that include this module.

  * Be extensible through polymorphism and plugins.

  * Abstract away I/O, so you can run this REPL on the command line or in your own event loop and expect the same behavior.

# Building

  * You need Luadoc (http://keplerproject.github.com/luadoc/) installed to build the documentation.

  * You need Test.More (http://fperrad.github.com/lua-TestMore/testmore.html) installed to run the tests.

# Compatibility

The current version of the software runs on Lua 5.1, LuaJIT ?.? etc.
A port to Lua 5.2 is envisaged, but is not at this stage a priority.
Since it is written purely in Lua, it should work on any platform that
has one of those versions of Lua installed.

XXX Check which version of LuaJIT this works with
XXX Check that it works with other Lua interpreters

# Installation

You can install lua-repl via LuaRocks:

    luarocks install luarepl

You can also install it by hand by copying the `repl`
directory to a location in your `package.path`, and
copying rep.lua to somewhere in your `PATH`.

# Recommended packages

`rep.lua` works best if you also have `linenoise` installed,
available from https://github.com/hoelzro/lua-linenoise.
`rep.lua` will fallback to using rlwrap if you have that as well;
without either of these, you will have command editing, history,
or other features generally provided by `readline`.

# Features

`rep.lua` prints the results of simple expressions without requiring
a `return ` or a `= ` in front of it.  If `linenoise` is installed,
it also offers persistent history and tab completion.  It also offers
a number of plugins; see plugins.md for a list of plugins that come
with lua-repl.
