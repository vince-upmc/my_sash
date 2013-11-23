/*
 * Copyright (c) 2013 by Vincent Botbol - Mathieu Chailloux
 * Permission is granted to use, distribute, or modify this source,
 * provided that this copyright notice remains intact.
 *
 * Most simple built-in commands are here.
 */
#include "eval-upmc.h"

void do_arith(int argc, const char ** argv){
  if (argc == 2)
    puts(eval(*(++argv)));
}

char* caml_eval(value expr){

  //=> monde ocaml
  CAMLparam1(expr);
  CAMLlocal2(res, exn);

  static value * f = NULL;

  // exceptions
  static value *inv_arg, *dbz, *undef;
  if (inv_arg == NULL) inv_arg = caml_named_value("invalid_arg");
  if (dbz == NULL) dbz = caml_named_value("div_by_0");
  if (undef == NULL) undef = caml_named_value("undef_op");
  
  
  if (f == NULL) f = caml_named_value("eval_expr");

  res = caml_callback_exn(*f,expr);

  if (Is_exception_result(res)){
    exn = Extract_exception(res);
    if (Field(exn, 0) == *inv_arg) CAMLreturnT(char*, "Invalid argument");
    if (Field(exn, 0) == *dbz) CAMLreturnT(char*, "Division by 0");
    if (Field(exn, 0) == *undef) CAMLreturnT(char*, "Undefined operation's semantic");
    else CAMLreturnT(char*, "Syntax error");
  }
  CAMLreturnT(char*, String_val(res));
  //c'était bien! 
  //=> monde C
}

char *eval(const char *expr){
   return caml_eval(caml_copy_string(expr));
}
