(*
** Course: Concepts of Programming Languages (BU CAS CS 320)
** Semester: Spring, 2013
** Instructor: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
** Teaching Fellow: Zhiqiang (Alex) Ren (aren AT cs DOT bu DOT edu)
*)

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/pointer.dats"
staload _(*anon*) = "prelude/DATS/reference.dats"

(* ****** ****** *)

staload _(*anonymous*) = "prelude/DATS/lazy.dats"

(* ****** ****** *)

staload _(*anonymous*) = "prelude/DATS/list.dats"
staload _(*anonymous*) = "prelude/DATS/list0.dats"
staload _(*anonymous*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload _(*anonymous*) = "prelude/DATS/array.dats"
staload _(*anonymous*) = "prelude/DATS/array0.dats"

(* ****** ****** *)

#define sz2i int_of_size
#define i2sz size_of_int

(* ****** ****** *)

#define nil0 list0_nil
#define cons0 list0_cons

#define Some0 option0_some
#define None0 option0_none

(* ****** ****** *)

extern
castfn list0_of_list {a:t@ype} (xs: List a):<> list0 a
extern
castfn list_of_list0 {a:t@ype} (xs: list0 a):<> List a

(* ****** ****** *)

extern
fun{a:t@ype} list0_is_nil (xs: list0 a): bool
extern
fun{a:t@ype} list0_is_cons (xs: list0 a): bool

(* ****** ****** *)

implement{a}
list0_is_nil (xs) =
  case+ xs of list0_nil () => true | _ => false
implement{a}
list0_is_cons (xs) =
  case+ xs of list0_cons _ => true | _ => false

(* ****** ****** *)

extern
fun{}
input_get_line_charlst (inp: FILEref): list0 (char)

implement{}
input_get_line_charlst (inp) = let
  val str = input_line_vt (inp)
  val isnot = strptr_isnot_null (str)
in
//
if isnot then let
  val cs = string_explode ($UN.castvwtp1 {String} (str))
  val () = strptr_free (str)
in
  list0_of_list_vt (cs)
end else let
  val () = strptr_free (str) in list0_nil ()
end // end of [if]
//
end // end of [input_line_charlst]

(* ****** ****** *)

extern
fun{
a:viewt@ype
} array0_exch (
  A: array0 a, i: size_t, j: size_t
) :<!exnref> void // endfun
implement{a}
array0_exch
  (A, i, j) = let
//
val A = array0_get_arrszref (A)
val (
  vbox pf_psz | p_psz
) = ref_get_view_ptr (A)
val i = size1_of_size (i)
val j = size1_of_size (j)
val p_data = p_psz->2; val asz = p_psz->3
//
in
//
if i < asz then (
  if j < asz then let
    prval pf_data = p_psz->1
    val () = array_ptr_exch<a> (!p_data, i, j)
    prval () = p_psz->1 := pf_data
  in
    // nothing
  end else (
    $raise ArraySubscriptException ()
  ) // end of [if]
) else (
  $raise ArraySubscriptException ()
) // end of [if]
//
end // end of [array0_exch]

(* ****** ****** *)

extern
fun{
a:viewt@ype
} array0_exch__intsz
  (A: array0 a, i: int, j: int):<!exnref> void
// end of [array0_exch__intsz]
implement{a}
array0_exch__intsz
  (A, i, j) = let
  val i = int1_of_int (i)
  val j = int1_of_int (j)
in
//
if i >= 0 then let
in
//
if j >= 0 then (
  array0_exch<a> (A, (i2sz)i, (i2sz)j)
) else $raise ArraySubscriptException ()
//
end else (
  $raise ArraySubscriptException ()
) // end of [if]
//
end (* end of [array0_exch__intsz] *)
  
(* ****** ****** *)

extern
fun{}
array0_make_string (str: string): array0 (char)
implement{}
array0_make_string (str) = let
  val [n:int] str =
    string1_of_string (str)
  val asz = string_length (str)
  val (pf_gc, pf_arr | p_arr) = array_ptr_alloc<char> (asz)
  val _(*ptr*) =
    memcpy (p_arr, str, asz) where {
    extern fun memcpy : (ptr, string, size_t) -> ptr = "mac#atslib_memcpy"
  } // end of [val]
  prval pf_arr =
    __assert (pf_arr) where {
    extern praxi __assert : {l:addr} (@[char?][n] @ l) -<prf> (@[char][n] @ l)
  } // end of [prval]
in
  array0_make_arrpsz {char} {n} @(pf_gc, pf_arr | p_arr, asz)
end // end of [array0_make_string]

(* ****** ****** *)

extern
fun{a:t0p}
array0_make_list0 (xs: list0 (a)): array0 (a)
implement{a}
array0_make_list0 (xs) = array0_make_lst (xs)

(* ****** ****** *)

extern
fun{a:t@ype}
list0_insert_at
  (xs: list0 (a), n: int, x0: a): list0 a
implement{a}
list0_insert_at (xs, n, x0) = let
//
fun
aux (
  xs: list0 (a), n: int, x0: a
) : list0 a = let
in
//
if n > 0 then (
  case+ xs of
  | list0_cons
      (x, xs) => list0_cons (x, aux (xs, n-1, x0))
  | list0_nil () => list0_cons (x0, list0_nil)
) else list0_cons (x0, xs)
//
end // end of [aux]
//
in
  if n >= 0
    then aux (xs, n, x0) else $raise ListSubscriptException()
  // end of [if]
end // end of [list0_remove_at]

(* ****** ****** *)

extern
fun{a:t@ype}
list0_remove_at
  (xs: list0 (a), n: int): (a, list0 a)
implement{a}
list0_remove_at (xs, n) = let
//
fun aux (
  xs: list0 a, n: int
) : (a, list0 a) = let
in
//
case+ xs of
| list0_cons (x, xs) =>
    if n > 0 then let
      val (x1, xs1) = list0_remove_at (xs, n-1)
    in
      (x1, list0_cons (x, xs1))
    end else (x, xs) // end of [if]
| list0_nil () => $raise ListSubscriptException()
//
end // end of [aux]
//
in
  if n >= 0 then aux (xs, n) else $raise ListSubscriptException()
end // end of [list0_remove_at]

(* ****** ****** *)

extern
fun{a:t@ype}
list0_iforeach
  (xs: list0 (a), f: (int, a) -<cloref1> void): void
implement{a}
list0_iforeach (xs, f) = list0_iforeach_cloref (xs, f)

(* ****** ****** *)

extern
fun{
ini:t@ype
}{
a:t@ype
} list0_foldleft
  (i0: ini, xs: list0 a, f: (ini, a) -<cloref1> ini): ini

implement{i}{a}
list0_foldleft (i0, xs, f) =
  case+ xs of
  | list0_cons
      (x, xs) => list0_foldleft (f (i0, x), xs, f)
  | list0_nil () => i0
// end of [list0_foldleft]

(* ****** ****** *)

extern
fun{
a:t@ype
}{
snk:t@ype
} list0_foldright
  (xs: list0 a, s0: snk, f: (a, snk) -<cloref1> snk): snk

implement{i}{a}
list0_foldright (xs, s0, f) =
  case+ xs of
  | list0_cons
      (x, xs) => f (x, list0_foldright (xs, s0, f))
  | list0_nil () => s0
// end of [list0_foldright]

(* ****** ****** *)

extern
fun{a:t@ype}
fprint_list0_sep (
  out: FILEref
, xs: list0(a), sep: string, fpr: (FILEref, a) -<cloref1> void
) : void // end of [fprint_list0_sep]
implement{a}
fprint_list0_sep
  (out, xs, sep, fpr) = let
in
  list0_iforeach_cloref<a> (xs
  , lam (i, x) =>
      (if i > 0 then fprint_string (out, sep); fpr (out, x))
    // end of [lam]
  )
end // end of [fprint_list0_sep]

(* ****** ****** *)

extern
fun{a:t@ype}
fprint_array0_sep (
  out: FILEref
, A: array0(a), sep: string, fpr: (FILEref, a) -<cloref1> void
) : void // end of [fprint_array0_sep]
implement{a}
fprint_array0_sep
  (out, A, sep, fpr) = let
in
  array0_iforeach<a> (A
  , lam (i, x) =>
      $effmask_all (if i > 0 then fprint_string (out, sep); fpr (out, x))
    // end of [lam]
  )
end // end of [fprint_array0_sep]

(* ****** ****** *)

extern
fun string_implode
  (cs: list0 char): string = "mac#atspre_string_implode"
extern
fun string_explode
  (str: string): list0 char = "mac#atspre_string_explode"

macdef string2list = string_explode

(* ****** ****** *)

extern
fun{
} string_make_list0_rev (cs: list0 (char)): string
implement{}
string_make_list0_rev (cs) = let
  val cs = list_of_list0 (cs); val n = list_length (cs)
in
  string_of_strbuf (string_make_list_rev_int (cs, n))
end // end of [string_make_list0_rev]

(* ****** ****** *)

staload _(*anon*) = "libc/SATS/stdio.sats"
staload _(*anon*) = "libc/SATS/stdlib.sats"
staload _(*anon*) = "libc/SATS/string.sats"
staload _(*anon*) = "libc/SATS/unistd.sats"

(* ****** ****** *)

extern
fun feof (fp: FILEref): int = "mac#atslib_feof"

(* ****** ****** *)

extern
fun string_contains
  (s: string, c: char): bool = "mac#atspre_string_contains"

(* ****** ****** *)

extern
fun strcmp
  (x1: string, x2: string):<> int = "mac#atslib_strcmp"
extern
fun strncmp
  (x1: string, x2: string, n: size_t):<> int = "mac#atslib_strncmp"

(* ****** ****** *)

extern
fun strcasecmp
  (x1: string, x2: string): int = "mac#atslib_strcasecmp"
extern
fun strncasecmp
  (x1: string, x2: string, n: size_t): int = "mac#atslib_strncasecmp"

(* ****** ****** *)

exception Domain of ()

extern fun{} randint (n: int): int

local
//
staload RAND = "libc/SATS/random.sats"
//
in // in of [local]

implement{}
randint (n) = let
  val n = int1_of_int (n) in
  if n > 0 then $RAND.randint (n) else $raise Domain ()
end // end of [randint]

end // end of [local]

(* ****** ****** *)

#if(0)
%{^
#ifndef ISNAN
#define ISNAN
extern int isnan (double x) ;
#endif // end of [ISNAN]
%} // end of [%{^]
extern fun isnan (x: double): int = "isnan" // declared in [math.h]?
#endif

(* ****** ****** *)

(* end of [BUCASCS320.hats] *)
