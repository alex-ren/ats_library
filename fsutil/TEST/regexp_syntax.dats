(*
** Regular expression matching
*)

(* ****** ****** *)

staload "regexp_syntax.sats"

(* ****** ****** *)

implement
fprint_regexp2
  (out, re0) = let
//
macdef prstr (s) = fprint_string (out, ,(s))
//
in
//
case+ re0 of
| REnul () => prstr "REnul()"
| REemp () => prstr "REemp()"
| REany () => prstr "REany()"
| REchar (c) => {
    val () = prstr "REchar("
    val () = fprint_char (out, c)
    val () = prstr ")"
  }
| REalt
    (re1, re2) => {
    val () = prstr "REalt("
    val () = fprint_regexp2 (out, re1)
    val () = prstr ", "
    val () = fprint_regexp2 (out, re2)
    val () = prstr ")"
  }
| REcat
    (re1, re2) => {
    val () = prstr "REcat("
    val () = fprint_regexp2 (out, re1)
    val () = prstr ", "
    val () = fprint_regexp2 (out, re2)
    val () = prstr ")"
  }
| REstar (re) => {
    val () = prstr "REstar("
    val () = fprint_regexp2 (out, re)
    val () = prstr ")"
  }
//
end // end of [fprint_regexp2]

(* ****** ****** *)

(* end of [regexp_syntax.dats] *)
