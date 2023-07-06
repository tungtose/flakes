let
  common = import ../common;
in
[
  ./imgview
  ./launcher
  ./notice
  ./kooha
  ./mpv
] ++ common
