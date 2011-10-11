LUA_FILES=$(shell find . -type f -name '*.lua')

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO
luarocks:
	# TODO
