Sash + arith extensions
===

This forked project contains :

- The removing of warning

- A simple extension that evaluate expressions



Sash readme
===

This is release 3.7 of sash, my stand-alone shell for Linux or other systems.

The purpose of this program is to make system recovery possible in
many cases where there are missing shared libraries or executables.
It does this by firstly being linked statically, and secondly by
including versions of many of the standard utilities within itself.
Read the sash.1 documentation for more details.

Type "make install" to build and install the program and man page.

Several options in the Makefile can be changed to build sash for
other UNIX-like systems.  In particular, dependencies on Linux file
systems can be removed and the mount command can be configured.

David I. Bell
dbell@canb.auug.org.au
12 January 2004
