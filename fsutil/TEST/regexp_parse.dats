(*
** Regular expression matching
*)

(* ****** ****** *)

#include "BUCASCS320-7.hats"

(* ****** ****** *)

staload "regexp_syntax.sats"

(* ****** ****** *)
//
// Examples:
//
// *.?ats -> REcats(REcat(REcat(REstar(REany), '.'), REany), 'ats')
//
(* ****** ****** *)

implement
regexp2_parse (rep) = let
//
val cs = string_explode (rep)
//
fun loop
(
  cs: list0 (char), res: list0 (regexp2)
) : list0 (regexp2) = let
in
//
case+ cs of
| list0_cons
    (c, cs) => let
    val re = (
      case+ c of
      | '?' => REany ()
      | '*' => REstar (REany ())
      | _ (*lit*) => REchar (c)
    ) : regexp2
  in
    loop (cs, list0_cons (re, res))
  end // end of [list0_cons]
| list0_nil () => res
//
end // end of [loop]
//
fun caten
(
  res: list0 (regexp2)
) : regexp2 =
  case+ res of
  | list0_cons
      (re, res) => REcat (caten (res), re)
  | list0_nil () => REemp ()
// end of [caten]
//
val rex = caten (loop (cs, list0_nil))
//
in
  rex
end // end of [regexp2_parse]

(* ****** ****** *)

(* end of [regexp_parse.dats] *)
