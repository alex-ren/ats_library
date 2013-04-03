(*
** Regular expression matching
*)

(* ****** ****** *)

abstype regexp_type
typedef regexp = regexp_type

(* ****** ****** *)

fun regexp_parse (rep: string): regexp

(* ****** ****** *)

(*

HX-2013-03-22: 40 points

Please implement a regular expression parser
that parses according to the following grammar:

lit ::= any char except #, ., |, *, (, and )
rex ::= . // a dot matches any single char
rex ::= '#' lit // escaped literal matching only [lit]
rex ::= rex rex // concatenation
rex ::= rex '|' rex // alternative
reg ::= rex '*' // this is the Kleene star
rex ::= '(' rex ')' // grouping

operator precedence: '*' > (concat) > '|'

Examples:

#a## => REcat(REchar'a', REchar'#')
a.b => REcat(REcat(REchar'a', REany()), REchar'b')
a|bc => REalt (REchar'a', REcat (REchar'b', REchar'c'))
a|bc* => REalt (REchar'a', REcat (REchar'b', REstar(REchar'c')))
(a|b)* => REstar(REalt (REchar'a', REchar'b'))

*)

fun regexp_parse2 (rep: string): regexp

(* ****** ****** *)

fun string_regexp_match (str: string, re: regexp): bool

(* ****** ****** *)

(* end of [regexp.sats] *)
