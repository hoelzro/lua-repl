# lua-repl release guide

  - [ ] Bump VERSION (in repl/init.lua, look for references to current version)
  - [ ] Update Changelog
  - [ ] Rename and update rockspec
  - [ ] Make sure tests pass
  - [ ] Push & tag latest release
  - [ ] Submit rockspec to luarocks
  - [ ] E-mail lua-l
  - [ ] Submit lua-l gmane link to reddit

## E-mail template for lua-l

Hi Lua users,

I have just released version {{VERSION}} of lua-repl, an alternative to the
standalone REPL included with Lua and a library for embedding a Lua
REPL within a Lua application.

lua-repl provides a library for adding a Lua REPL to your Lua-powered
application.  It also provides an example REPL in the form of rep.lua,
which can take the place of the standalone interpreter provided with
Lua.  It has a plugin facility; plugins for things like history and tab
completion of symbols are included in the lua-repl distribution.

{{CHANGES}}

You can install lua-repl via Luarocks (called luarepl there), or
manually from the source [{{REFERENCE}}].

-Rob

[{{REFERENCE}}] https://github.com/hoelzro/lua-repl/archive/0.8.tar.gz

