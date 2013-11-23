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
exception Invalid_arg
exception Div_by_0
exception Undef_op

type op_kind = Plus | Minus | Mult | Div | Mod | Range | Access

type ast = 
  | Num of float
  | Var of string
  | Op of op_kind * ast * ast
  | List of ast list
  | Array of ast array

let string_of_op_kind = function
  | Plus -> "+" 
  | Minus -> "-" 
  | Mult -> "*" 
  | Div -> "/" 
  | Mod -> "%"
  | Range -> ".." 
  | Access -> ":"

let rec string_of_ast = function
  | Num f -> string_of_float f
  | Var n -> n
  | Op (op, g, d) -> "(" ^ (string_of_ast g) ^ (string_of_op_kind op) ^ (string_of_ast d) ^ ")"
  | List l -> "[" ^ (String.concat ";" (List.map string_of_ast l)) ^ "]"
  | Array arr -> "{" ^ (String.concat ";" (List.map string_of_ast (Array.to_list arr))) ^ "}"

(* Var doit contenir un flottant. *)
let fetch_variable var = 
  try
    if var != "$$" then
      Unix.getenv var
    else 
      string_of_int (Unix.getpid ())
  with
    | Not_found -> Printf.fprintf stderr "Warning : %s undefined - set to 0\n%!" var; "0.0"
    | Failure _ -> raise Invalid_arg
      (* raise (Error (var ^ " isn't a constant")) *)

let fetch_op = function
  | Plus -> (+.)
  | Minus -> (-.) 
  | Mult -> ( *. ) 
  | Div -> ( /. )
  | Mod -> (fun x y -> float_of_int ((int_of_float x) mod (int_of_float y)))
  | _ -> assert false

(* ~Semop *)
let apply_op op (g : ast) (d : ast) : ast =
  let f_op = fetch_op op in
  match g, d with
    | Num v1, Num v2 -> Num (f_op v1 v2)
    | List l1, List l2  when (match op with Plus -> true | _ -> false) -> 
      List (l1 @ l2)

    | Array a1, Array a2 when (match op with Plus -> true | _ -> false) ->
      Array (Array.append a1 a2)

    | List l, Num v when (match op with Plus -> true | _ -> false) -> List (l@[d])
    | Num v, List l when (match op with Plus -> true | _ -> false) -> List (g::l)

(*
    | Array a, Num v
    | Num v, Array a -> Array (Array.map (f_op v) a)
*)
    | _ -> 
      raise Undef_op

let create_ranged_list = function 
  | Num g, Num d ->
    let l = ref [] in
    let g_i = int_of_float g in
    let d_i = int_of_float d in
    let max_v = max g_i d_i in
    let min_v = min g_i d_i in
    for i = min_v to max_v do
      l := Num(float_of_int i)::!l
    done; 
    List (if max_v = d_i then List.rev !l else !l)

  | Num _, err
  | err, Num _
  | err, _ -> raise Invalid_arg
    (* (Error ((string_of_ast err) ^ " was supposed to be a value")) *)

let access_tab = function 
  | Array ar, Num d ->
    let len = Array.length ar in
    let idx = ref (int_of_float d) in
    while !idx < len do
      idx := !idx + len
    done;
    if !idx != 0 then idx := !idx mod len;
    ar.(!idx)

  | Array _, err (* -> 
     raise (Error ((string_of_ast err) ^ " was supposed to be a value")) *)
  | err, _ -> raise Invalid_arg
(* raise (Error ((string_of_ast err) ^ " was supposed to be an array")) *)

let rec eval reparse : ast -> ast = function
  | Num f -> Num f
  | Var n -> 
    (* dangerous loop ahead *)
    eval reparse (reparse (Lexing.from_string (fetch_variable n)))
  | List l -> List (List.map (eval reparse) l)
  | Array a -> Array (Array.map (eval reparse) a)

  | Op (Range, g, d) ->
    let g = eval reparse g in
    let d = eval reparse d in
    create_ranged_list (g,d)

  | Op (Access, g, d) ->
    let g = eval reparse g in
    let d = eval reparse d in
    access_tab (g, d)
    
  | Op (op, g, d) -> 
    let g = eval reparse g in 
    let d = eval reparse d in
    match op, d with
      | Div, Num(0.0) | Mod, Num(0.0) -> raise Div_by_0 
      | _ -> apply_op op g d
