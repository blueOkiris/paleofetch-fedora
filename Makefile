# Settings

## Compiler settings

CC :=		gcc
CFLAGS :=	-O2 -Wall -Wextra \
			-I include
LD :=		gcc
LDFLAGS :=	-lX11 -lpci

## Install settings

PREFIX :=	$(HOME)/.local
CACHE :=	$(shell if [ "$$XDG_CACHE_HOME" ]; then echo "$$XDG_CACHE_HOME"; else echo "$$HOME"/.cache; fi)

## Project settings

OBJNAME :=	paleofetch
SRC :=		$(wildcard src/*.c)
HFILES :=	$(wildcard include/*.h)
OBJS :=		$(subst src/,obj/,$(subst .c,.o,$(SRC)))

# Targets

## Helper targets

.PHONY: all
all: $(OBJNAME)

clean:
	rm -rf $(OBJNAME) $(CACHE)/$(OBJNAME) obj/

install: $(OBJNAME)
	mkdir -p $(PREFIX)/bin
	install ./$(OBJNAME) $(PREFIX)/bin/$(OBJNAME)

obj/%.o: src/%.c $(HFILES)
	mkdir -p obj/
	$(eval battery_path := $(shell ./config_scripts/battery_config.sh))
	$(CC) -o $@ $(CFLAGS) -c $< -D $(battery_path)

## Main target(s)

$(OBJNAME): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)
	strip $@

