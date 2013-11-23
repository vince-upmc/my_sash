Sash + arith extensions
===

This forked project contains :

- The removing of warning

- A simple extension that evaluate expressions

Basic examples :
      - \-echo $[1+2*3] displays 7
      - \-arith '1+(2*3)' displays 9
      - setenv TWO 2
        \-echo $[1+$TWO] displays 3

Advanced types :
	 - Lists :
	   It is possible to define lists with this syntax : [e1; e2; ... ; en]
	   We can also use the range operator '..' : [e1 .. en ].
	   This will result in the creation of a list starting from e1 to en.
	   examples : \-echo $[[1;2;3]] displays [1;2;3]
	   	      \-echo $[[1..4]] displays [1;2;3;4]
	   	      \-echo $[[4..1]] displays [4;3;2;1]

	 - Arrays :
	   The syntax for declaring arrays is : {e1; ...; en}
	   To access the element N, we use the operator '.' : {e1; ..; eN}.(N-1)
	   The array is cyclic thus given the index -1, 
	   we will get the Nth element.
	   Also, given the index N, we will access the first element, 
	   N+2 the second etc.
	   examples : \-echo $[{1;2;3}] displays {1;2;3}
	   	      \-echo $[{1;2;3}.(2)] displays 3
	   	      \-echo $[{1;2;3}.(3)] displays 1

Operators :
	  A few operators are defined.
	  If the semantic is not given, it can result in an error.

	  - '+' does a basic addition if given two reducable numbers
	    If given :
	     - two lists : it appends these lists
	     - an integer n and a list l  : push n in the list's head
	     - a list l and an integer n : append n at the end of the list
	     - Two arrays : append the given arrays

	  - '-' does a substraction if given two reducable numbers
	  
	  - '/' does a division if given two reducable numbers
	    outputs an error if given 0 as a right sided expression

	  - '%' apply the modulo operator if given two reducable numbers
	    outputs an error if given 0 as the right-side expression

	  - '*' does a multiplication if given two reducable numbers

Expression examples -- should be called either with $[expr] or with single or double quotes if called by the \-arith command

1 + 2 + [1;2;3] => [3;1;2;3]
[1;2;3] + 4 => [1;2;3;4]
[1;2] + [3;4] => [1;2;3;4]

# setenv TWO 2
{4;5;6}.(-3) * 10 + $TWO => 42 

# setenv AR {1;2;3}
$AR.(1) % 2 => 0
$AR + $AR => {1;2;3;1;2;3}

# setenv L {8..10}
$L + [7..1] => [8;9;10;7;6;5;4;3;2;1]

3 / {-3;-2;-1;0}.(-1) => Error : Division by zero

Contact : vincent.botbol@etu.upmc.fr mathieu.chailloux@etu.upmc.fr

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
