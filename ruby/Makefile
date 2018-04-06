all: html
html: index.html
index.html: index.md ruby.erb
	TITLE=`grep "title:" index.md |sed -e "s/title: //"` ; sed -e "s/{{ page.title }}/$$TITLE/" -e  "1,/---/ d" index.md | kramdown --template=ruby.erb>$@
zip: ruby.zip
ruby.zip: index.html ruby.css img/*
	zip -9 $@ $?
clean:
	-rm index.html ruby.zip
.PHONY: all zip clean html
