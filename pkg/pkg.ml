#!/usr/bin/env ocaml

let () =
  begin match Sys.getenv_opt "OCAMLTOP_INCLUDE_PATH" with
  | None -> prerr_endline "OCAMLTOP_INCLUDE_PATH undefined"
  | Some v ->
      prerr_endline ("OCAMLTOP_INCLUDE_PATH=" ^ v);
      begin
        try Topdirs.dir_directory (Sys.getenv "OCAMLTOP_INCLUDE_PATH")
        with Not_found -> ()
      end;
      if Sys.file_exists (v ^ Filename.dir_sep ^ "topfind")
      then prerr_endline "OCAMLTOP_INCLUDE_PATH found topfind"
      else prerr_endline "OCAMLTOP_INCLUDE_PATH topfind nonexistent"
  end;
  begin match Sys.getenv_opt "OCAML_TOPLEVEL_PATH" with
  | None -> prerr_endline "OCAML_TOPLEVEL_PATH undefined"
  | Some v ->
      prerr_endline ("OCAML_TOPLEVEL_PATH=" ^ v);
      begin
        try Topdirs.dir_directory (Sys.getenv "OCAML_TOPLEVEL_PATH")
        with Not_found -> ()
      end;
      if Sys.file_exists (v ^ Filename.dir_sep ^ "topfind")
      then prerr_endline "OCAML_TOPLEVEL_PATH found topfind"
      else prerr_endline "OCAML_TOPLEVEL_PATH topfind nonexistent"
  end;
;;

#use "topfind"
#require "topkg"
open Topkg

let unix = Conf.with_pkg "base-unix"
let cmdliner = Conf.with_pkg "cmdliner"

let () =
  Pkg.describe "fmt" @@ fun c ->
  let unix = Conf.value c unix in
  let cmdliner = Conf.value c cmdliner in
  Ok [ Pkg.mllib "src/fmt.mllib";
       Pkg.mllib ~cond:unix "src/fmt_tty.mllib";
       Pkg.mllib ~cond:cmdliner "src/fmt_cli.mllib";
       Pkg.mllib ~api:[] "src/fmt_top.mllib";
       Pkg.lib "src/fmt_tty_top_init.ml";
       Pkg.test "test/test"; ]
