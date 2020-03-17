T    := tfnohup2dat
PATH := $(PATH):UTIL
SRC  := $(T:%=%.pl)
README := README.md

all: $T

$T: %: %.pl *.pl */*.pl | CONFIG.pl
	perlpp $< > $@
	@chmod 755 $@

CONFIG.pl: $(SRC) Makefile
	mkversionpl | grep -v MKDIR > $@.bkp; mv $@.bkp $@

install: all
	makeinstall -f $T

README.md: $T
	$< -h | man2md > $@

clean:
	rm -fv README.md
	rm -fv $T

-include ~/.github/Makefile.git
