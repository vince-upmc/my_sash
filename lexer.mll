(*
 * Copyright (c) 2013 by Vincent Botbol - Mathieu Chailloux
 * Permission is granted to use, distribute, or modify this source,
 * provided that this copyright notice remains intact.
 *
 * Most simple built-in commands are here.
 *)
{ 
  open Parser

  let (>>) f h = h f
}

let dollar = '$'
let var =  ['a'-'z''A'-'Z'] ['a'-'z''A'-'Z''0'-'9']*
let number = ['0'-'9']* '.'? ['0'-'9']+


let lparen = '('
let rparen = ')'
let lbracket = '['
let rbracket = ']'
let laccol = '{'
let raccol = '}'
let semicol = ';'

let op_mod = '%'
let op_dotdot = ".."
let op_dot = "."
let op_plus = '+'
let op_minus = "-"
let op_div = '/'
let op_mult = "*"

let space = ['\t' ' ' '\n']*

rule token = parse
  | space
      {token lexbuf}
  | number as n
      { NUM(n >> float_of_string) }
  | var as n
      { VAR(n) }

  | dollar { DOLLAR }

  | lparen { LPAREN }
  | rparen { RPAREN }
  | lbracket { LBRACKET }
  | rbracket { RBRACKET }
  | laccol { LACCOL }
  | raccol { RACCOL }
  | semicol { SEMICOL }

  | op_dotdot { DOTDOT }
  | op_dot { DOT }
  | op_plus { PLUS } 
  | op_minus { MINUS }
  | op_div { DIV }
  | op_mod { MOD }
  | op_mult { MULT }

  | eof { EOF }
  | _ 
      { failwith ("Unknown symbol " ^ Lexing.lexeme lexbuf) }

{
}
