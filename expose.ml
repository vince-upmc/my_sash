(*
 * Copyright (c) 2013 by Vincent Botbol - Mathieu Chailloux
 * Permission is granted to use, distribute, or modify this source,
 * provided that this copyright notice remains intact.
 *
 * Most simple built-in commands are here.
 *)
open Parser
open Lexer
open Eval

let rec eval_expr str = 
  let lexbuf = Lexing.from_string str in
  string_of_ast (eval (Parser.start Lexer.token) (Parser.start Lexer.token lexbuf))

let () =
  begin
    Callback.register "eval_expr" eval_expr;
    let open Eval in
    Callback.register_exception "invalid_arg" Invalid_arg;
    Callback.register_exception "div_by_0" Div_by_0;
    Callback.register_exception "undef_op" Undef_op;
  end
    


(* 
   let () =
   eval_expr "[1..10] + 5 * 4 + {1;2;10;11}.($DEUX)"
(* eval_expr "1 + (-2 * 3)" *)
*)
