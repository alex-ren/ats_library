
%{#
#include "fsutil.cats"
%}

abstype dirent_ptr_t = $extype "struct dirent *"
typedef dirent_ptr = dirent_ptr_t


abstype dir_ptr_t = $extype "DIR *"
typedef dir_ptr = dir_ptr_t

abst@ype stat_t = $extype "struct stat"
typedef stat = stat_t

//
(* ****** ****** *)


(* ****** ****** *)

(*
  return:
      0  : O.K.
      -1 : Error
*)
fun opendir (name: string, d: &dir_ptr? >> dir_ptr): int = "ats_fsutil_opendir"

fun closedir (d: dir_ptr): int = "ats_fsutil_closedir"

(*
  return:
      0  : O.K.
      -1 : Error
*)
fun readdir (d: dir_ptr, df: &dirent_ptr? >> dirent_ptr): int = "ats_fsutil_readdir"

fun dirent_get_name (x: dirent_ptr): string = "ats_fsutil_get_name"

fun dirent_isfile (x: dirent_ptr): bool = "ats_fsutil_dirent_isfile"
fun dirent_isdir (x: dirent_ptr): bool = "ats_fsutil_dirent_isdir"

(*
  return:
      0  : O.K.
      -1 : Error
*)
fun realpath (path: string, resolved: &string? >> string): int = "ats_fsutil_realpath"

(*
  return:
      0  : O.K.
      -1 : Error
*)
fun get_stat (path: string, st: &stat_t? >> stat_t): int = "ats_fsutil_get_stat"

fun stat_isfile (st: &stat): bool = "ats_fsutil_stat_isfile"
fun stat_isdir (st: &stat): bool = "ats_fsutil_stat_isdir"




