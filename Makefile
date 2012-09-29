LUA_FILES=$(shell find repl -type f -name '*.lua')
.PHONY: doc install

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO

test:
	LUA_PATH=';;?.lua;?/init.lua' prove

clean:
	rm -rf doc/
