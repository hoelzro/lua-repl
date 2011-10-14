LUA_FILES=$(shell find repl/ -type f -name '*.lua')
.PHONY: doc install

doc:
	luadoc -d doc $(LUA_FILES)

install:
	# TODO

test:
	# TODO

clean:
	rm -rf doc/
