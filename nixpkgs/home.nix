{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "gat";
  home.homeDirectory = "/home/gat";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
  home = {
    sessionVariables = {
      EDITOR="emacsclient -t";
      VISUAL="emacsclient -c -a emacs";
    };
  };

  programs.alacritty = {
    enable = true;
  };
  programs.zsh = {
    enable = true; 
    initExtra = "autoload -U promptinit; promptinit\n 
                 prompt pure";
    shellAliases = {
      gits = "cd ~/Documents/sources";
      ran = "ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd \"$LASTDIR\"";
      pls = "sudo $(fc -ln -1)";
      vim = "emacsclient -nw $1";
      dota = "steam-run ~/.steam/steam/steamapps/common/dota\ 2\ beta/game/dota.sh"; # Keep using this until https://github.com/NixOS/nixpkgs/issues/128021 gets fixed
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" ];
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";      
        };
      }
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  home.packages = with pkgs; [
    gnomeExtensions.paperwm
    gnomeExtensions.cleaner-overview
    gnomeExtensions.vertical-overview
    gnomeExtensions.disable-workspace-switch-animation-for-gnome-40
    pure-prompt
    ranger
    tldr
  ];
  home.sessionPath = [ "~/.emacs.d/bin"];
}