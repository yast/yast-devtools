%.ps: %.dot
	dot -Tps -o $@ $<
%.dot: %.notr.dot
	tred $< > $@
.PRECIOUS: %.dot
