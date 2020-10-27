all: upeek upoke

upoke: upoke.c
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

upeek: upeek.c
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	-rm -f upeek upoke *.rpm
