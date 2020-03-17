# auto-update to the last devel versions

CK_="\\033[90m"
CD_="\\033[0m"

SRC := $(shell find . -type f -name '*.pl' | sed s:./::)
DEP := $(SRC:%.pl=.%.dep)
OK  := $(SRC:%.pl=.%.ok)

all: $(OK)

.%.ok: .%.dep
	@touch $@

%.pl:
	cp $< $@

# "built" is place for devel versions ("installed" for stable)
.%.dep: %.pl
	@printf "$(CK_)mkpldep $*.pl > $@$(CD_)\n"
	@grep '^# built: ' $*.pl | sed 's/^# built: /$*.pl: /' > $@

clean:
	rm -fv .*.dep
	rm -fv .*.ok

-include $(DEP)
