#
# Makefile for sash
#
# The HAVE_GZIP definition adds the -gzip and -gunzip commands.
# The HAVE_LINUX_ATTR definition adds the -chattr and -lsattr commands.
# The HAVE_LINUX_MOUNT definition makes -mount and -umount work on Linux.
# The HAVE_BSD_MOUNT definition makes -mount and -umount work on BSD.
# The MOUNT_TYPE definition sets the default file system type for -mount.
#
HAVE_GZIP		= 1
HAVE_LINUX_ATTR		= 0
HAVE_LINUX_MOUNT	= 0
HAVE_BSD_MOUNT		= 0
MOUNT_TYPE		= '"ext3"'

CC=gcc

# Modify this if the compiler cannot find the caml libs
OCAML_LIBS=$(shell echo -n `dirname \`which ocamlc\``/../lib/ocaml)

OCAMLCC=ocamlc
OCAMLYACC=ocamlyacc
OCAMLLEX=ocamllex

CFLAGS = -Wall -Wextra -Wmissing-prototypes \
	-DHAVE_GZIP=$(HAVE_GZIP) \
	-DHAVE_LINUX_ATTR=$(HAVE_LINUX_ATTR) \
	-DHAVE_LINUX_MOUNT=$(HAVE_LINUX_MOUNT) \
	-DHAVE_BSD_MOUNT=$(HAVE_BSD_MOUNT) \
	-DMOUNT_TYPE=$(MOUNT_TYPE) \
	-I$(OCAML_LIBS)

#LDFLAGS = -static -s
LIBS = -lz -ldl -lm -ltermcap


BINDIR = /bin
MANDIR = /usr/man/man1

MLOBJS=eval.cmo parser.cmo lexer.cmo expose.cmo

MLGEN=parser.ml parser.mli lexer.ml

OBJS =  sash.o cmds.o cmd_dd.o cmd_ed.o cmd_grep.o cmd_ls.o cmd_tar.o \
	cmd_gzip.o cmd_find.o cmd_file.o cmd_chattr.o cmd_ar.o eval-upmc.o \
	utils.o

CAML_OBJ=expose.o

sash:	$(OBJS) $(CAML_OBJ)
	$(CC) $(LDFLAGS) $(CAML_OBJ) $(OBJS) -L$(OCAML_LIBS) -lunix -lcamlrun $(LIBS) -o $@

run: sash
	rlwrap ./sash
clean:
	rm -f $(OBJS) $(CAML_OBJ) sash *~ $(MLOBJS) $(MLGEN) *.cm[dti] *.cm[dt][it]

install: sash
	cp sash $(BINDIR)/sash
	cp sash.1 $(MANDIR)/sash.1

$(OBJS): sash.h


%.cmo: %.ml
	$(OCAMLCC) -c $<
%.cmi: %.mli
	$(OCAMLCC) -c $<

parser.cmo:parser.cmi parser.mly
lexer.cmo: parser.cmo lexer.ml

parser.ml: parser.mli parser.mly
parser.mli: parser.mly
	$(OCAMLYACC) $<

%.ml: %.mll
	$(OCAMLLEX) $<

$(CAML_OBJ): $(MLOBJS)
	$(OCAMLCC) -custom -output-obj -o $@ unix.cma $^
