(*    SASH + ARITHMETIC EXTENSION
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
