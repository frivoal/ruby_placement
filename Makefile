all: html
html: ruby.html
ruby.html: ruby.md ruby.erb
	kramdown --template=ruby.erb ruby.md >$@
zip: ruby.zip
ruby.zip: ruby.html ruby.css img/*
	zip -9 $@ $?
clean:
	rm ruby.html ruby.zip
.PHONY: all zip clean html
