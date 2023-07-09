# Settings

## Compiler settings

CC :=		gcc
CFLAGS :=	-O2 -Wall -Wextra \
			-I include
LD :=		gcc
LDFLAGS :=	-lX11 -lpci

## Install settings

CACHE :=	$(shell if [ "$$XDG_CACHE_HOME" ]; then echo "$$XDG_CACHE_HOME"; else echo "$$HOME"/.cache; fi)

## Project settings

OBJNAME :=	paleofetch
SRC :=		$(wildcard src/*.c)
HFILES :=	$(wildcard include/*.h) $(wildcard include/logos/*.h)
OBJS :=		$(subst src/,obj/,$(subst .c,.o,$(SRC)))

# Targets

## Helper targets

.PHONY: all
all: $(OBJNAME)

clean:
	rm -rf $(OBJNAME) $(CACHE)/$(OBJNAME) obj/

obj/%.o: src/%.c $(HFILES)
	mkdir -p obj/
	$(CC) -o $@ $(CFLAGS) -c $< -D BATTERY_DIRECTORY='"/sys/class/power_supply/BAT1"'

## Main target(s)

$(OBJNAME): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)
	strip $@

