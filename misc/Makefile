%.ps: %.dot
	dot -Tps -o $@ $<
%.dot: %.notr.dot
	tred $< > $@
.PRECIOUS: %.dot

all: import.ps import-pkg.ps import-clu.ps
