.PHONY: all build clean serve

all: build

build:
	sh ./build.sh

clean:
	rm -rf public

serve: build
	sh ./serve.sh