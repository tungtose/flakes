{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      g = "lazygit";
      update = "cd /home/tung/projects/flakes && sudo nixos-rebuild switch --flake .#laptop";
      uflake = "cd /home/tung/projects/flakes && sudo nixos-rebuild switch --flake .#laptop";
      fl = "cd /home/tung/projects/flakes";
      fb = "sudo nixos-rebuild switch --flake .#laptop";
      up = "fl && fb";
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
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
