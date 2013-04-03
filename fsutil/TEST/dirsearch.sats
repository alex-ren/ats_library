(* ****** ****** *)
(*
//
// HX: generic graph search
//
*)
(* ****** ****** *)
//
// for directory entries
//
abstype dirfile_type
typedef dirfile = dirfile_type
//
(* ****** ****** *)

fun dirfile_is_dir (x: dirfile): bool
fun dirfile_is_file (x: dirfile): bool

(* ****** ****** *)

fun dirfile_get_name (x: dirfile): string
fun dirfile_get_fullpath (x: dirfile): string
fun dirfile_get_children (x: dirfile): list0 (dirfile)

(* ****** ****** *)

fun dirfile_getby_name (name: string): option0 (dirfile)

(* ****** ****** *)

(*
//
// HX-2013-03-22: 20 Points
//
The higher-order function [dirsearch] collects all the
directory entries satisfying a given predicate; it does
so by traversing the directory of a given name and all
of its subdirectories.
*)

fun dirsearch
  (name: string, f: dirfile -<cloref1> bool): list0 (dirfile)
// end of [dirsearch]

(* ****** ****** *)

(* end of [dirsearch.sats] *)
