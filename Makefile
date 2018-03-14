all: ruby.html
ruby.html: ruby.md
	kramdown ruby.md >ruby.html
