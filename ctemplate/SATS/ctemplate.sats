(***********************************************************************)
(* *)
(* Applied Type System *)
(* *)
(* Hongwei Xi *)
(* *)
(***********************************************************************)

(*
** ATS - Unleashing the Potential of Types!
** Copyright (C) 2002-2010 Hongwei Xi, Boston University
** All rights reserved
**
** ATS is free software; you can redistribute it and/or modify it under
** the terms of the GNU General Public License as published by the Free
** Software Foundation; either version 2.1, or (at your option) any later
** version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without even the implied warranty of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
** for more details.
**
** You should have received a copy of the GNU General Public License
** along with ATS; see the file COPYING. If not, write to the Free
** Software Foundation, 51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)

(*
**
** Contributed by Zhiqiang Ren (aren AT cs DOT bu DOT edu)
** Start Time: Oct, 2012
**
*)

(* ****** ****** *)

%{#
#include "ctemplate.cats"
%} // end of [%{#]


// #define ATS_STAFLAGLOAD 0 // no static loading at run-time

absviewtype template_dict_vt

abstype template_dict_ptr

fun atslib_ctemplate_template_dict_new (name: string): template_dict_vt = 
  "atslib_ctemplate_template_dict_new"
fun atslib_ctemplate_template_dict_delete (tp: template_dict_vt): void = 
  "atslib_ctemplate_template_dict_new"

// fun atslib_zlog_fini (): void = "mac#zlog_fini"
// 
// typedef zlog_category_ptr (p: addr) = $extype "zlog_category_t *"
// 
// typedef zlog_category_ptr0 = [p: addr] zlog_category_ptr p
// 
// fun atslib_zlog_category_not_null {p: addr}
//   (cat: zlog_category_ptr p): bool (p > null) =
//   "mac#atslib_zlog_category_not_null"
// 
// fun atslib_zlog_get_category (cname: string): zlog_category_ptr0 =
//   "mac#atslib_zlog_get_category"

(* ****** ****** *)
