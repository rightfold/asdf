SCSSC=sassc
SCSSCFLAGS=--precision 10

PSALM=vendor/bin/psalm

COMPOSER=composer

build: static/application.css type-check

static/application.css: static/application.scss
static/application.css:
	${SCSSC} ${SCSSCFLAGS} $< $@

.PHONY: type-check
type-check:
	${PSALM}

.PHONY: dependencies
dependencies:
	${COMPOSER} install
