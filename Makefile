LUA_FILES=$(shell find repl -type f -name '*.lua')
.PHONY: doc install

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO

test:
	LUA_INIT='' LUA_PATH=';;$(LUA_PATH);?.lua;?/init.lua;t/lib/?.lua' prove

clean:
	rm -rf doc/
