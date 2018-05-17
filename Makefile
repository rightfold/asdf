.PHONY: all
all: build

.PHONY: clean
clean:
	rm -rf build

.PHONY: dependencies
dependencies:
	make -C php dependencies

.PHONY: build
build:
	make -C cobol build
	make -C php build

.PHONY: test
test: unit-test integration-test

.PHONY: unit-test
unit-test:
	make -C cobol unit-test

.PHONY: integration-test
integration-test:
	make -C integration-test
