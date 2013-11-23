(*  SASH + ARITHMETIC EXTENSION
    Copyright (C) 2013 Vincent Botbol - Mathieu Chailloux

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
