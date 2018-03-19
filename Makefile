all: ruby.html
ruby.html: ruby.md ruby.erb
	kramdown --template=ruby.erb ruby.md >ruby.html
