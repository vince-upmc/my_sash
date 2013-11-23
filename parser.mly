/*  SASH + ARITHMETIC EXTENSION
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
*/
%{

  open Eval
  
  
%}


/* values */
%token <float> NUM
%token <string> VAR

/* punctuation */
%token LPAREN RPAREN LBRACKET RBRACKET LACCOL RACCOL SEMICOL DOLLAR

/* operators */
%token PLUS MINUS DIV MULT MOD DOT DOTDOT

%token EOF

%left PLUS , MINUS
%left MULT , DIV , MOD
%left DOTDOT

%start start
%type <Eval.ast> start
%type <Eval.ast> expr
%type <Eval.ast> liste
%type <Eval.ast> array

%%
start:
| expr EOF { $1 }

expr:
  | DOLLAR VAR { Var $2 }

  | NUM { Num $1 }
  | MINUS NUM { Num (-. $2) }

  | liste { $1 }

  | array { $1 }

  | expr PLUS expr { Op (Plus, $1, $3) }
  | expr MINUS expr { Op (Minus, $1, $3) }
  | expr MULT expr { Op (Mult, $1, $3) }
  | expr DIV expr { Op (Div, $1, $3) }
  | expr MOD expr { Op (Mod, $1, $3) }

  | LPAREN expr RPAREN { $2 }

  | array DOT LPAREN expr RPAREN { Op(Access, $1, $4) }

      list_expr:
  | expr { [$1] }
  | expr SEMICOL list_expr { $1::$3 }
      
      liste:
  | DOLLAR VAR { Var $2 }
  | LBRACKET list_expr RBRACKET { List $2 }
  | LBRACKET expr DOTDOT expr RBRACKET { Op(Range, $2, $4) }
      
      array:
  | DOLLAR VAR { Var $2 }
  | LACCOL list_expr RACCOL { Array (Array.of_list $2) }


%%
