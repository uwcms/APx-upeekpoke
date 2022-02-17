CFLAGS := $(CFLAGS) -Wall

all: upeek upoke

upoke: upoke.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

upeek: upeek.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	-rm -f upeek upoke *.rpm
