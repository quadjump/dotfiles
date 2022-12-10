# Options at https://nix-community.github.io/home-manager/options.html
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "quadjump";
  home.homeDirectory = "/home/quadjump";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };
  nixpkgs.config.pkgs.firefox.enableGnomeExtensions = true; # https://unix.stackexchange.com/a/437249 - "How can I install GNOME shell extensions from extensions.gnome.org through Firefox on NixOS?"

  # ssbm = {
  #   options.ssbm = {
  #     # overlay.enable = mkEnableOption "Activate the package overlay.";
  #     cache.enable = true; # "Turn on cache."
  #     gcc.oc-kmod.enable = true;  # "Turn on overclocking kernel module."
  #     gcc.rules.enable = true;  # "Turn on rules for your gamecube controller adapter."
  #     # gcc.rules.rules = mkOption {
  #     #   default = readFile ./gcc.rules;
  #     #   type = types.lines;
  #     #   description = "To be appended to services.udev.extraRules if gcc.rules.enable is set.";
  #     # };
  #     # keyb0xx = {
  #     #   enable = mkEnableOption "Add keyb0xx to your binary path";
  #     #   config = mkOption {
  #     #     default = readFile ./keyb0xx/config.h;
  #     #     type = types.lines;
  #     #     description = "Config.h file to compile keyb0xx with.";
  #     #   };
  #     # };
  #   };
  # };

  home.packages = with pkgs; [
    # Desktop Applications
    _1password-gui
    alacritty
    emacs
    firefox
    vscode
    opensnitch-ui
    mullvad-vpn
    zeal

    # Gaming
    dolphin-emu  # Gamecube/Wii/Triforce emulator
    # ssbm.nixosModule  # Slippi Melee - https://github.com/djanatyn/ssbm-nix/blob/524c757ec88e8cc149809fb452b3c007d1134c22/flake.nix#L56

    # CLI Programs
    bat
    delta
    tldr
    tree

    # Nix-specific Tools
    haskellPackages.nix-derivation
    nix-direnv
    nix-tree
    nixpkgs-fmt
    rnix-lsp

    # Other
  ];

  ##### Program Configurations ###############################################################
  programs.direnv.enable = true;
  programs.direnv = {
    enableBashIntegration = true;
    nix-direnv.enable = true;
    # config = {};
    # stdlib = "";
  };

  programs.exa.enable = true;
  programs.exa.enableAliases = false;

  programs.firefox = {
    enable = true;
    extensions = # Helpful blog: https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
      with pkgs.nur.repos.rycee.firefox-addons; [
        # Find in https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
        # Good privacy resource - https://restoreprivacy.com/
        cookie-autodelete
        decentraleyes # Blocks shitty CDN trojan fuckery served alongside actual content
        i-dont-care-about-cookies # Removes cookie warning by removing element or auto-accepting
        onepassword-password-manager
        reddit-enhancement-suite
        ublock-origin
      ];
    package = pkgs.firefox.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      cfg = {
        # Gnome shell native connector
        enableGnomeExtensions = true;
        # Tridactyl native connector
        #enableTridactylNative = true;
      };
    };
    profiles.default = {
      # New firefox needs profile, else above configurations won't work
      id = 0;
      name = "Default";
      isDefault = true;
      # settings = {  # See options in ~/.mozilla/firefox/default/prefs.js
      #   "app.update.auto" = false;
      #   "browser.startup.homepage" = "https://search.nixos.org/packages"
      #   "browser.urlbar.placeholderName" = "DuckDuckGo";
      # };
      bookmarks = [
        {
          name = "Tech";
          toolbar = true;
          bookmarks = [
            {
              name = "HN";
              url = "https://hn.premii.com/";
            }
            {
              name = "HN Algolia";
              url = "https://hn.algolia.com/?dateRange=all&page=0&prefix=true&query=&sort=byPopularity&type=all";
            }
          ];
        }
        {
          name = "Nix";
          toolbar = true;
          bookmarks = [
            {
              name = "Nixpkgs";
              url = "https://search.nixos.org/packages";
            }
            {
              # Home Manager Manual
              name = "Home-Manager Manual";
              url = "https://nix-community.github.io/home-manager/";
            }
            {
              # Home Manager Configuration Options
              name = "Home-Manager Options";
              url = "https://nix-community.github.io/home-manager/options.html";
            }
            {
              # Nix User Repositories
              name = "Nur - Nix User Repositories";
              url = "https://nur.nix-community.org/";
            }
          ];
        }
      ];
    };
  };

  programs.fzf.enable = true;
  programs.fzf = {
    enableBashIntegration = true;
  };

  programs.git.enable = true;
  programs.git = {
    delta.enable = true;
    # diff-so-fancy.enable = true;
    # difftastic.enable = true;
    ignores = [ ];
    userEmail = "krypton-00fallout@icloud.com";
    userName = "quadjump";
  };

  programs.jq.enable = true;

  programs.nix-index.enable = true;
  programs.nix-index = {
    enableBashIntegration = true;
  };

  # programs.nushell.enable = true;
  # programs.nushell = {};

  programs.pandoc.enable = true;

  programs.pylint.enable = true;
  programs.pylint = {
    settings = { };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Nix
      bbenoist.nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      # Haskell
      haskell.haskell
      # Python
      ms-python.python
      ms-python.vscode-pylance
      # Documentation
      yzhang.markdown-all-in-one
      # Configuration
      tamasfe.even-better-toml
      # Theme
      # Tooling
      eamodio.gitlens
      # General
    ]

    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        # Mypy
        name = "mypy";
        publisher = "matangover";
        version = "0.2.2";
        sha256 = "sha256-eaiR30HjPCpOLUKQqiQ2Oqj+XY+JNnV47bM5KD2Mouk=";
      }
      {
        # Run python doctests inline like HLS
        name = "python-inline-repl";
        publisher = "zijie";
        version = "0.0.1";
        sha256 = "sha256-rn/ZR5OgDaxAGB+Q0FJ3Vx1VIAVosoZq1A5z+hptiI0=";
      }
      {
        # Access documentation with Zeal (linux kapeli/Dash.app alternetive)
        name = "vscode-dash"; # configure in vscode's settings.json through nix
        publisher = "deerawan";
        version = "2.4.0";
        sha256 = "sha256-Yqn59ppNWQRMWGYVLLWofogds+4t/WRRtSSfomPWQy4=";
      }
    ];
    userSettings = {
      # General
      "files.autoSave" = "on";
      "update.channel" = "none";
      "window.zoomLevel" = 1;

      # Nix
      "[nix]"."editor.tabSize" = 2;
      "nix.enableLanguageServer" = true;
      "nixEnvSelector.packages" = [ ];

      # Python
      "python.linting.mypyEnabled" = true;
    };
  };
}
