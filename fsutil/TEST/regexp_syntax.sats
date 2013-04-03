(*
** Regular expression matching
*)

(* ****** ****** *)

datatype
regexp2 =
  | REnul of ()
  | REemp of ()
  | REany of ()
  | REchar of (char)
  | REalt of (regexp2, regexp2)
  | REcat of (regexp2, regexp2)
  | REstar of (regexp2)
// end of [regexp2]

(* ****** ****** *)
//
fun fprint_regexp2
  (out: FILEref, re: regexp2): void
overload fprint with fprint_regexp2

(* ****** ****** *)

fun regexp2_parse (rep: string): regexp2

(* ****** ****** *)
//
// HX: for Assignment 7
//
fun regexp2_parse2 (rep: string): regexp2
//
(* ****** ****** *)

fun string_regexp2_match (str: string, re: regexp2): bool

(* ****** ****** *)

(* end of [regexp_syntax.sats] *)
