all: build-en build-nl
	true

.PHONY: clean
clean:
	rm -rf build output

build-%: build-html-% build-purs-% build-scss-%
	true

.PHONY: build-html-%
build-html-%:
	mkdir -p build
	cat src/index.html | sed 's/{{ASDF_LANG}}/$*/g' > build/index.$*.html

.PHONY: build-purs-%
build-purs-%:
	mkdir -p build
	../i18n/messages-purs.pl ASDF.I18N < ../i18n/messages.$*.txt \
	                                   > build/ASDF.I18N.$*.purs
	psc-package build -- build/ASDF.I18N.$*.purs
	psc-bundle output/*/{index,foreign}.js \
		--output build/amalgamation.$*.js \
		--main Main

.PHONY: build-scss-%
build-scss-%:
	mkdir -p build
	sassc --precision 10 src/Stylesheet.scss build/amalgamation.$*.css
