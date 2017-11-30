module StrSet = Set.Make(String)
module StrMap = Map.Make(String)

[@@@ocaml.warning "-3"]

type package_name = string
[@@deriving yojson]

type package_version = {
  homepage : string option;
  keywords : string list;
  categories : string list;
  authors : string list;
  description : string option;
  date : string option;
  version : string;
  suite : string;
} [@@deriving yojson]

type package_info = {
  versions : package_version list;
  most_recent : string;
} [@@deriving yojson]

type packages = (string * package_info) list [@@deriving yojson]

[@@@ocaml.warning "+3"]

module PkgVersionSet = Set.Make(struct
  type t = package_version
  let compare p1 p2 = String.compare p1.version p2.version
end)

let warning s = Printf.eprintf "W: %s\n%!" s

let (/) = Filename.concat

let parse_args v =
  match Array.to_list v with
  | [] | [_] -> Printf.eprintf "archive2web root1 root2..."; exit 1
  | _ :: roots -> roots

let read_file fname =
  let ic = open_in fname in
  let b = Buffer.create 1024 in
  Buffer.add_channel b ic (in_channel_length ic);
  Buffer.contents b

let strip_prefix prefix fullname =
  let len_prefix = String.length prefix in
  String.sub fullname len_prefix (String.length fullname - len_prefix)

let fold_subdirs base acc f = Array.fold_left f acc (Sys.readdir base)

open OpamParserTypes

let has_tilde s =
  let len = String.length s in
  if s.[len - 1] = '~' then String.sub s 0 (len-1), true
  else s, false

let digits v =
  let v, tilde = has_tilde v in
  try
    match String.split_on_char '.' v with
    | [] -> int_of_string v, 0, tilde
    | [x] -> int_of_string x, 0, tilde
    | x :: y :: _ -> int_of_string x, int_of_string y, tilde
  with Failure _ -> warning "incomplete version parsing"; 0,0,false


let rec find_var_str name = function
  | [] -> None
  | Variable(_,n,String(_,v)) :: _ when name = n -> Some v
  | _ :: xs -> find_var_str name xs

let rec find_var_str_list name = function
  | [] -> []
  | Variable(_,n,List(_,vl)) :: _ when name = n ->
       List.map (function String(_,s) -> s | _ -> assert false) vl
  | _ :: xs -> find_var_str_list name xs

let rec find_var name = function
  | [] -> None
  | Variable(_,n,v) :: _ when name = n -> Some v
  | _ :: xs -> find_var name xs

let has_prefix prefix s =
  let len_prefix = String.length prefix in
  let len = String.length s in
  if len > len_prefix && String.sub s 0 len_prefix = prefix then
    Some (String.sub s len_prefix (len - len_prefix))
  else None

let rec filtermap f = function
  | [] -> []
  | x :: xs ->
      match f x with Some x -> x :: filtermap f xs | _ -> filtermap f xs

let parse_author_name s =
  let r = Str.regexp "[^<]*" in
  if Str.string_match r s 0 then
    Str.matched_string s
  else raise (Invalid_argument "author_name")

let extract_package_version_data ~suite ~version opam_file =
  let tags = find_var_str_list "tags" opam_file in
  let date =
    match filtermap (has_prefix "date:") tags with
    | [] -> None
    | [x] -> Some x
    | x :: _ -> warning "multiple date tag"; Some x in
  let homepage = find_var_str "homepage" opam_file in
  let description = find_var_str "description" opam_file in
  let description = match description with
    | None -> find_var_str "synopsis" opam_file
    | Some _ -> description
  in
  let tags = find_var_str_list "tags" opam_file in
  let keywords = filtermap (has_prefix "keyword:") tags in
  let categories = filtermap (has_prefix "category:") tags in
  let authors = find_var_str_list "authors" opam_file in
  let authors = List.map parse_author_name authors in
  { version;
    homepage;
    keywords;
    categories;
    authors;
    description;
    date;
    suite;
  }

let do_one_package_version root pname version =
  let pdir = pname ^ "." ^ version in
  let package_file s = root / "packages" / pname / pdir / s in
  let { OpamParserTypes.file_contents; _ } = OpamParser.file (package_file "opam") in
  extract_package_version_data ~suite:root ~version file_contents

let merge_package_versions p1 p2 =
  { versions = p1.versions @ p2.versions;
    most_recent =
      if OpamVersionCompare.compare p1.most_recent p2.most_recent < 0 then
        p2.most_recent else p1.most_recent }

let do_one_package pkgs ~versions root name =
  let versions = List.rev (List.sort OpamVersionCompare.compare versions) in
  let most_recent = List.hd versions in
  let versions = List.map (do_one_package_version root name) versions in
  let pkg = { versions; most_recent } in
  StrMap.update name (function None -> Some pkg | Some pkg' -> Some (merge_package_versions pkg' pkg)) pkgs

let get_version pname pdir = strip_prefix (pname ^ ".") (Filename.basename pdir)

let do_one_suite pkgs root =
  fold_subdirs (root / "packages") pkgs (fun pkgs pname ->
      let versions =
        fold_subdirs (root / "packages" / pname) [] (fun versions pdir ->
            get_version pname pdir :: versions)
      in
      do_one_package pkgs ~versions root pname)

let () =
  let roots = parse_args Sys.argv in
  let packages = List.fold_left do_one_suite StrMap.empty roots in
  print_endline @@ Yojson.Safe.to_string @@ packages_to_yojson @@ StrMap.bindings packages
