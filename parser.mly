/*
 * Copyright (c) 2013 by Vincent Botbol - Mathieu Chailloux
 * Permission is granted to use, distribute, or modify this source,
 * provided that this copyright notice remains intact.
 *
 * Most simple built-in commands are here.
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
  | LBRACKET list_expr RBRACKET { List $2 }
  | LBRACKET expr DOTDOT expr RBRACKET { Op(Range, $2, $4) }
      
      array:
  | LACCOL list_expr RACCOL { Array (Array.of_list $2) }


%%
