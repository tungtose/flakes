{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    shell = "/etc/profiles/per-user/tung/bin/zsh";

    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
      ];

    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1

      set -g default-terminal "xterm-256color"
      #set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",xterm-256color:Tc"

      # action key
      unbind C-b
      set-option -g prefix C-t
      set-option -g repeat-time 0

      thm_bg="#303446"
      thm_fg="#c6d0f5"
      thm_cyan="#99d1db"
      thm_black="#292c3c"
      thm_gray="#414559"
      thm_magenta="#ca9ee6"
      thm_pink="#f4b8e4"
      thm_red="#e78284"
      thm_green="#a6d189"
      thm_yellow="#e5c890"
      thm_blue="#8caaee"
      thm_orange="#ef9f76"
      thm_black4="#626880"

      set-window-option -g mode-keys vi

      #bind t send-key C-t
      # Reload settings
      bind r source-file ~/.config/tmux.conf \; display "Reloaded!"
      # Open current directory
      bind o run-shell "open #{pane_current_path}"
      bind -r e kill-pane -a

      # vim-like pane switching
      bind -r k select-pane -U 
      bind -r j select-pane -D 
      bind -r h select-pane -L 
      bind -r l select-pane -R 

      # Moving window
      bind-key -n C-S-Left swap-window -t -1 \; previous-window
      bind-key -n C-S-Right swap-window -t +1 \; next-window

      # Resizing pane
      bind -r C-k resize-pane -U 5
      bind -r C-j resize-pane -D 5
      bind -r C-h resize-pane -L 5
      bind -r C-l resize-pane -R 5

      #### basic settings

      set-option -g status-justify "left"
      set-window-option -g mode-keys vi
      set -sg escape-time 10

      # allow the title bar to adapt to whatever host you connect to
      set -g set-titles on
      set -g set-titles-string "#T"

      bind -T root F12  \
        set prefix None \;\
        set key-table off \;\
        set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
        set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
        set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
        if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
        refresh-client -S \;\

      bind -T off F12 \
        set -u prefix \;\
        set -u key-table \;\
        set -u status-style \;\
        set -u window-status-current-style \;\
        set -u window-status-current-format \;\
        refresh-client -S


      wg_user_host="#[fg=$color_secondary]#(whoami)#[default]@#H"
      wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"
      set -g status-right "$wg_is_keys_off | $wg_user_host"
    '';
  };

  home.packages = [
    # Open tmux for current project.
    (pkgs.writeShellApplication {
      name = "pux";
      runtimeInputs = [ pkgs.tmux ];
      text = ''
        PRJ="''$(zoxide query -i)"
        echo "Launching tmux for ''$PRJ"
        set -x
        cd "''$PRJ" && \
          exec tmux -S "''$PRJ".tmux attach
      '';
    })
  ];
}
