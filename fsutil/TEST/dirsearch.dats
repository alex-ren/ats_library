//
// Title: Concepts of Programming Languages
// Number: CAS CS 320
// Semester: Fall 2012
// Class Time: TR 12:30-2:00
// Instructor: Hongwei Xi (hwxiATcsDOTbuDOTedu)
// Teaching Fellow: Alex Ren (arenATcsDOTbuDOTedu)
//

(* ****** ****** *)

#include
"BUCASCS320-7.hats"

(* ****** ****** *)

staload "dirsearch.sats"

staload fsutil = "fsutil.sats"

typedef dir = $fsutil.dir_ptr
typedef dirent = $fsutil.dirent_ptr
typedef stat = $fsutil.stat

datatype file_type =
| dir_t of ()
| file_t of ()

typedef dirfile_t = '{file_type = file_type, name = string, fullpath = string}

assume dirfile_type = dirfile_t

implement dirfile_is_dir (x) =
case+ x.file_type of
| dir_t () => true
| _ => false

implement dirfile_is_file (x) =
case+ x.file_type of
| file_t () => true
| _ => false

implement dirfile_get_name (x) = x.name

implement dirfile_get_fullpath (x) = x.fullpath

implement dirfile_get_children (x) = let
  // val () = println! ("dirfile_get_children of: " + dirfile_get_name (x))
  var d: dir?
  val ret = $fsutil.opendir (x.fullpath, d)
in
  if ret != 0 then list0_nil ()  (* open dir fail *)
  else let
    fun loop (d: dir, accu: list0 (dirfile)):<cloref1> list0 (dirfile) = let
      var de: dirent?
      val ret = $fsutil.readdir (d, de)
    in
      if ret != 0 then accu  // read dir fail
      else if $fsutil.dirent_isfile (de) || $fsutil.dirent_isdir (de) then let
        val ftype = if $fsutil.dirent_isfile (de) then file_t () else dir_t ()
        val name = $fsutil.dirent_get_name (de)
      in
        if name = "." || name = ".." then loop (d, accu) // trivial file, skip
        else let
          var fullpath: string?
          val ret = $fsutil.realpath (x.fullpath + "/" + name, fullpath)
        in
          if ret != 0 then accu
          else let
            val dirfile = '{file_type = ftype, name = name, fullpath = fullpath}
          in
            loop (d, list0_cons (dirfile, accu))
          end
        end
      end
      else loop (d, accu)  // neither regular file nor directory, skip
    end

    val files = loop (d, list0_nil ())
    val _ = $fsutil.closedir (d)
  in
    files
  end
end

implement dirfile_getby_name (name) = let
  // val () = println! ("dirfile_getby_name")
  var fullpath: string?
  val ret = $fsutil.realpath (name, fullpath)
in
  if ret != 0 then option0_none ()
  else let
    var st: stat?
    val ret = $fsutil.get_stat (name, st)
  in
    if ret != 0 then option0_none ()
    else if $fsutil.stat_isfile (st) then
      option0_some ('{file_type = file_t (), name = name, fullpath = fullpath})
    else if $fsutil.stat_isdir (st) then
      option0_some ('{file_type = dir_t (), name = name, fullpath = fullpath})
    else option0_none ()
  end
end

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

(*
fun dirsearch
  (name: string, f: dirfile -> bool): list0 (dirfile)
// end of [dirsearch]
*)

(* ****** ****** *)

local

fun auxdfs
(
  dfs: list0 (dirfile)
, f: dirfile -<cloref1> bool
, res: list0 (dirfile)
) : list0 (dirfile) = let
  // val () = println! ("auxdfs")
in
//
case+ dfs of
| list0_cons
    (df, dfs) => let
    val res =
    (
      if f (df) then list0_cons (df, res) else res
    ) : list0 (dirfile)
    val dfs_new = dirfile_get_children (df)
  in
    auxdfs (list0_append (dfs_new, dfs), f, res)
  end // end of [list0_cons]
| list0_nil () => res
//
end // end of [auxdfs]

in (* in of [local] *)

implement
dirsearch
  (name, f) = let
  val opt = dirfile_getby_name (name)
in
//
case+ opt of
| Some0 df => let
    val dfs =
      list0_cons (df, list0_nil)
    // end of [val]
  in
    auxdfs (dfs, f, list0_nil ())
  end // end of [Some0]
| None0 () => list0_nil ()
//
end // end of [dirsearch]

end // end of [local]

(* ****** ****** *)

(* end of [dirsearch.dats] *)
