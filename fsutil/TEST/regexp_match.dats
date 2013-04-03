(*
** Regular expression matching
*)

(* ****** ****** *)

#include "BUCASCS320-7.hats"

(* ****** ****** *)

staload "regexp_syntax.sats"

(* ****** ****** *)

extern
fun accept
(
  cs: list0 (char), re: regexp2, k: list0 (char) -<cloref1> bool
) : bool // end of [accept]

(* ****** ****** *)

implement
string_regexp2_match
  (str, re) = let
  val cs = string_explode (str)
in
  accept (cs, re, lam cs => list0_is_nil (cs))
end // end of [string_regexp2_match]

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

fun
list0_eqref
  {a:t@ype}
(
  xs: list0 (a), ys: list0 (a)
) : bool =
  $UN.cast{ptr}(xs) = $UN.cast{ptr}(ys)
// end of [list0_eqref]

overload = with list0_eqref

(* ****** ****** *)

implement
accept
  (cs, re0, k) = let
in
//
case+ re0 of
| REnul () => false
| REemp () => k (cs)
| REany () =>
  (
    case+ cs of
    | list0_cons (_, cs1) => k (cs1) | list0_nil () => false
  )
| REchar (c0) =>
  (
    case+ cs of
    | list0_cons (c1, cs1) =>
        if c0 = c1 then k (cs1) else false
    | list0_nil () => false
  )
| REalt (re1, re2) =>
  (
    if accept (cs, re1, k)
      then true else accept (cs, re2, k)
    // end of [if]
  ) // end of [REalt]
| REcat (re1, re2) =>
  (
    accept (cs, re1, lam cs1 => accept (cs1, re2, k))
  ) // end of [REalt]
| REstar (re) =>
  (
    if k (cs) then true else
      accept (cs, re, lam (cs1) => if cs = cs1 then false else accept (cs1, re0, k))
    // end of [if]
  )
//
end // end of [accept]

(* ****** ****** *)

(* end of [regexp_match.dats] *)
