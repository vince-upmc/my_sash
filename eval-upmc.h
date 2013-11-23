/*
 * Copyright (c) 2013 by Vincent Botbol - Mathieu Chailloux
 * Permission is granted to use, distribute, or modify this source,
 * provided that this copyright notice remains intact.
 *
 * Most simple built-in commands are here.
 */
#include <stdio.h>
#include <string.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

void do_arith(int argc, const char ** argv);
char *caml_eval(value);
char *eval(const char *);
