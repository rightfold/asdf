COBC=cobc
COBCFLAGS=-std=mf -Wall -I src/business

COB_SOURCES=$(shell find src/ -name '*.cob')
COB_OBJECTS=$(patsubst src/%.cob,build/src/%,${COB_SOURCES})

COB_UT_SOURCES=$(shell find unit-test -name '*.cob')
COB_UT_OBJECTS=$(patsubst unit-test/%.cob,build/unit-test/%,${COB_UT_SOURCES})
COB_UT_RUN=$(patsubst unit-test/%.cob,unit-test/%,${COB_UT_SOURCES})

CBL_SOURCES=$(shell find src -name '*.cbl')
CBL_OBJECTS=$(patsubst src/%.cbl,build/src/%.cbl.o,${CBL_SOURCES})

all: build

.PHONY: clean
clean:
	rm -rf build

build: ${COB_OBJECTS}

test: unit-test

.PHONY: unit-test
unit-test: ${COB_UT_RUN}

.PHONY: unit-test/%
unit-test/%: build/unit-test/%
	$<

build/src/%: src/%.cob ${CBL_OBJECTS}
	mkdir -p $(dir $@)
	${COBC} -x -o $@ $^ ${COBCFLAGS}

build/unit-test/%: unit-test/%.cob ${CBL_OBJECTS}
	mkdir -p $(dir $@)
	${COBC} -x -o $@ $^ ${COBCFLAGS}

build/src/%.cbl.o: src/%.cbl
	mkdir -p $(dir $@)
	${COBC} -c -o $@ $^ ${COBCFLAGS}
