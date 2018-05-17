COBC=cobc
COBCFLAGS=-std=mf -Wall -Isrc

TARGET_DIR=../build/cobol

COB_SOURCES=$(shell find src unit-test -name '*.cob')
COB_EXECUTABLES=$(patsubst %.cob,${TARGET_DIR}/%.cob.out,${COB_SOURCES})

CBL_SOURCES=$(shell find src unit-test -name '*.cbl')
CBL_OBJECTS=$(patsubst %.cbl,${TARGET_DIR}/%.cbl.o,${CBL_SOURCES})

build: ${COB_EXECUTABLES}

.PHONY: unit-test
unit-test: build
	for f in ${TARGET_DIR}/unit-test/*.cob.out; do         \
		"$$f" || exit $?;                                  \
	done

${TARGET_DIR}/%.cob.out: %.cob ${CBL_OBJECTS}
	mkdir -p $(dir $@)
	${COBC} -x -o $@ $^ ${COBCFLAGS}

${TARGET_DIR}/%.cbl.o: %.cbl
	mkdir -p $(dir $@)
	${COBC} -c -o $@ $^ ${COBCFLAGS}
