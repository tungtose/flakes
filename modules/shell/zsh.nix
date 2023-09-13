{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;

    sessionVariables = {
      # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux#configuration-variables
      # automatically start tmux
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOCONNECT = "false";
      ZSH_TMUX_CONFIG = "$XDG_CONFIG_HOME/tmux/tmux.conf";
    };

    shellAliases = {
      ll = "ls -l";
      g = "lazygit";
      update = "cd /home/tung/projects/flakes && sudo nixos-rebuild switch --flake .#laptop";
      uflake = "cd /home/tung/projects/flakes && sudo nixos-rebuild switch --flake .#laptop";
      fl = "cd /home/tung/projects/flakes";
      fb = "sudo nixos-rebuild switch --flake .#laptop";
      fbg = "sudo nixos-rebuild switch --upgrade --flake .#laptop";
      fw = "sudo nixos-rebuild switch --flake .#trash";
      up = "fl && fb";
      upg = "fl && fbg";
      upwsl = "fl && fw";
      v = "nvim";
      vf = "fd --type f --hidden --exclude .git | fzf-tmux | xargs nvim";
      cdf = "cd $(fd --type directory  --hidden | fzf-tmux)";
    };

    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "tmux" ];
      theme = "robbyrussell";
    };
  };
}
