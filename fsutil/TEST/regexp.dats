(*
** Regular expression matching
*)

(* ****** ****** *)

staload "regexp.sats"
staload "regexp_syntax.sats"

(* ****** ****** *)

assume regexp_type = regexp2

(* ****** ****** *)

implement
regexp_parse (rep) = regexp2_parse (rep)

implement
regexp_parse2 (rep) = regexp2_parse2 (rep)

(* ****** ****** *)

implement
string_regexp_match (str, re) = string_regexp2_match (str, re)

(* ****** ****** *)

(* end of [regexp.dats] *)
