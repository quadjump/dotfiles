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
  nixpkgs.config.pkgs.firefox.enableGnomeExtensions = true;  # https://unix.stackexchange.com/a/437249 - "How can I install GNOME shell extensions from extensions.gnome.org through Firefox on NixOS?"

  home.packages = with pkgs; [
    # Desktop Applications
    _1password-gui
    alacritty
    emacs
    firefox
    vscode
    opensnitch-ui
    mullvad-vpn

    # CLI Programs
    bat
    delta
    tldr
    tree

    # Nix-specific Tools
    nix-tree

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
    extensions =  # Helpful blog: https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
      with pkgs.nur.repos.rycee.firefox-addons; [
        # Find in https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
        # Good privacy resource - https://restoreprivacy.com/
        cookie-autodelete
        decentraleyes  # Blocks shitty CDN trojan fuckery served alongside actual content
        i-dont-care-about-cookies  # Removes cookie warning by removing element or auto-accepting
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
    profiles.default = {  # New firefox needs profile, else above configurations won't work
      id = 0;
      name = "Default";
      isDefault = true;
      # settings = {  # See options in ~/.mozilla/firefox/default/prefs.js
      #   "app.update.auto" = false;
      #   "browser.startup.homepage" = "https://search.nixos.org/packages"
      #   "browser.urlbar.placeholderName" = "DuckDuckGo";
      # };
      bookmarks = {
        nixpkgs = {
          keyword = "Nixpkgs";
          url = "https://search.nixos.org/packages";
        };
        home-manager = {  # Home Manager Manual
          keyword = "hmm"; 
          url = "https://nix-community.github.io/home-manager/";
        };
        home-manager-opt = {  # Home Manager Configuration Options
          keyword = "hmo"; 
          url = "https://nix-community.github.io/home-manager/options.html";
        };
        nur = {  # Nix User Repositories
          keyword = "nur";
          url = "https://nur.nix-community.org/";
        };
      };
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
    ignores = [];
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
    settings = {};
  };

  programs.vscode = {
    enable = true;
    extensions = [
      # Nix
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.arrterian.nix-env-selector
      # Haskell
      pkgs.vscode-extensions.haskell.haskell
      # Python
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.vscode-pylance
      # Documentation
      pkgs.vscode-extensions.yzhang.markdown-all-in-one
      # Theme
      # Tooling
      pkgs.vscode-extensions.eamodio.gitlens
      # General
    ];
    #package = vscode-1.68.1 # default
  };
}
