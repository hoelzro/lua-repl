LUA_FILES=$(shell find repl/ -type f -name '*.lua')
.PHONY: doc install

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO

test:
	tsc tests/*.lua

clean:
	rm -rf doc/
