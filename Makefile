LUA_FILES=$(shell find . -type f -name '*.lua')
.PHONY: doc install

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO
luarocks:
	# TODO
