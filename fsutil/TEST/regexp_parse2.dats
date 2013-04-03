(*
** Regular expression matching
*)

(* ****** ****** *)

#include "BUCASCS320-7.hats"

(* ****** ****** *)

staload "regexp_syntax.sats"

(* ****** ****** *)

typedef charlst = list0 (char)

(* ****** ****** *)

exception SyntaxError of ()

(* ****** ****** *)

typedef kregexp2 = regexp2 -<cloref1> regexp2

(* ****** ****** *)

extern
fun p_rex0 (cs: charlst): (regexp2, charlst)
extern
fun p_krex0 (cs: charlst): (kregexp2, charlst)

extern
fun p_rex1 (cs: charlst): (regexp2, charlst)
extern
fun p_krex1 (cs: charlst): (kregexp2, charlst)

extern
fun p_rex2 (cs: charlst): (regexp2, charlst)
extern
fun p_krex2 (cs: charlst): (kregexp2, charlst)

extern
fun p_grex (cs: charlst): (regexp2, charlst)

(* ****** ****** *)

extern
fun p_char (cs: charlst): (regexp2, charlst)
extern
fun p_litchar (cs: charlst, c0: char): charlst
extern
fun p_rparen (cs: charlst): charlst

(* ****** ****** *)

implement
p_rex0 (cs) = let
in
//
case+ cs of
| list0_cons
    (c, cs2) => (
  case+ c of
  | '#' => p_char (cs2)
  | '.' => (REany (), cs2)
  | '\(' => let
      val (re, cs2) = p_grex (cs2)
      val cs2 = p_rparen (cs2) // matching RPAREN
    in
      (re, cs2)
    end
  | _(*lit*) => (REchar (c), cs2)
  )
| list0_nil () => $raise SyntaxError ()
//
end // end of [p_rex0]

implement
p_krex0 (cs) = let
in
//
case+ cs of
| list0_cons
    (c, cs2) => (
  case+ c of
  | '*' => let
      val (kr, cs2) = p_krex0 (cs2)
    in
      (lam re => kr (REstar (re)), cs2)
    end
  | _ => (lam re => re, cs)
  )
| list0_nil () => (lam re => re, list0_nil ())
//
end // end of [p_krex0]

(* ****** ****** *)

implement
p_rex1 (cs) = let
  val (re, cs) = p_rex0 (cs)
  val (kre, cs) = p_krex0 (cs)
in
  (kre (re), cs)
end // end of [p_rex1]

implement
p_krex1 (cs) = let
in
//
case+ cs of
| list0_cons
    (c, _) => (
  case+ c of
  | '|' => (lam re => re, cs)
  | ')' => (lam re => re, cs)
  | _(**) => let
      val (re, cs) = p_rex1 (cs)
      val (kre, cs) = p_krex1 (cs)
    in
      (lam re0 => kre (REcat (re0, re)), cs)
    end
  )
| list0_nil () => (lam re => re, list0_nil ())
//
end // end of [p_krex1]

(* ****** ****** *)

implement
p_rex2 (cs) = let
  val (re, cs) = p_rex1 (cs)
  val (kre, cs) = p_krex1 (cs)
in
  (kre (re), cs)
end // end of [p_rex2]

implement
p_krex2 (cs) = let
in
//
case+ cs of
| list0_cons
    (c, cs2) => (
  case+ c of
  | '|' => let
      val (re, cs2) = p_rex2 (cs2)
      val (kre, cs2) = p_krex2 (cs2)
    in
      (lam re0 => kre (REalt (re0, re)), cs2)
    end
  | _ => (lam re => re, cs)
  )
| list0_nil () => (lam re => re, list0_nil ())
//
end // end of [p_krex2]

(* ****** ****** *)

implement
p_grex (cs) = let
  val (re, cs) = p_rex2 (cs)
  val (kre, cs) = p_krex2 (cs)
in
  (kre (re), cs)
end // end of [p_grex]

(* ****** ****** *)

implement
p_char (cs) =
(
case+ cs of
| list0_cons
    (c, cs2) => (REchar c, cs2)
| list0_nil () => $raise SyntaxError ()
) // end of [p_char]

(* ****** ****** *)

implement
p_litchar (cs, c0) =
(
case+ cs of
| list0_cons
    (c, cs) =>
  (
    if c = c0 then cs else $raise SyntaxError ()
  )
| list0_nil () => $raise SyntaxError ()
) // end of [p_litchar]

(* ****** ****** *)

implement
p_rparen (cs) = p_litchar (cs, ')')

(* ****** ****** *)

implement
regexp2_parse2 (rep) = let
//
val cs = string_explode (rep)
//
in
//
case+ cs of
| list0_cons _ => let
    val (rex, cs2) = p_grex (cs)
//
    val out = stdout_ref
    val () = fprintln! (out, "regexp2_parse2: rex = ", rex)
//
  in
    case+ cs2 of
    | list0_nil () => rex
    | list0_cons _ => $raise SyntaxError ()
  end
| list0_nil () => REemp ()
//
end // end of [regexp2_parse2]

(* ****** ****** *)

(* end of [regexp_parse2.dats] *)
