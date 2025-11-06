{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./go
    ./js
    ./lua
    ./php
    ./python
    ./rust
    ./zig
  ];
}
