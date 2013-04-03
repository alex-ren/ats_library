//
// little testing ...
//
staload "regexp.sats"
staload "regexp_syntax.sats"
staload "dirsearch.sats"
staload "fsutil.sats"
//
dynload "regexp.dats"
dynload "regexp_syntax.dats"
dynload "regexp_parse.dats"
dynload "regexp_parse2.dats"
dynload "regexp_match.dats"

dynload "dirsearch.dats"

(* ****** ****** *)

(* usage: ./regexp_test abc#..* ../test *)
implement
main (argc, argv) = let
//
val inp = stdin_ref
val out = stdout_ref
//
val () = assertloc (argc >= 3)
(*
val rex = regexp_parse (argv.[1])
*)
val rex = regexp_parse2 (argv.[1])
val path = argv.[2]
fun cmp (f: dirfile):<cloref1> bool = 
  string_regexp_match (dirfile_get_name (f), rex)

val files = dirsearch (path, cmp)

//
fun loop
(
  outp: FILEref, files: list0 (dirfile)
) : void = 
case+ files of
| list0_cons (fd, tail) => 
  (println! (dirfile_get_name fd); 
   println! ("    - " + dirfile_get_fullpath fd); 
   loop (outp, tail))
| list0_nil () => println! ()

//
in
  loop (stdout_ref, files)
end // end of [main]

(* ****** ****** *)

(* end of [regexp_test.dats] *)
