all: html
html: index.html
index.html: index.md ruby.erb
	kramdown --template=ruby.erb index.md >$@
zip: ruby.zip
ruby.zip: index.html ruby.css img/*
	zip -9 $@ $?
clean:
	-rm index.html ruby.zip
.PHONY: all zip clean html
