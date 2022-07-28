# Copied from https://github.com/floyza/dotfiles/blob/13dac04f3cd9dc63701e162037fba828047d7cfc/modules/ssbm/default.nix
{ config, lib, pkgs, ... }:

# let 
#   ssbm = import (builtins.fetchGit {
#       url = "git@github.com:djanatyn/ssbm-nix.git";
#       rev = "524c757ec88e8cc149809fb452b3c007d1134c22";
#       # sha256 = "3b2de54224963ee17857a9737b65d49edc423e06ad7e9c9b85d9f69ca923676a";
#     }
#   );

# in

{
  # ssbm = {};
  ssbm = {
    overlay.enable = true;
    cache.enable = true;
    gcc = {
      oc-kmod.enable = true;
      rules.enable = true;
    };
  };
}
