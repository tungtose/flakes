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

    plugins = with pkgs; [
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
      set-option -g default-shell /bin/zsh
      #### Key bindings

      set-window-option -g mode-keys vi

      #bind t send-key C-t
      # Reload settings
      bind r source-file ~/.tmux.conf \; display "Reloaded!"
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
      #set-option utf8-default on
      #set-option -g mouse-select-pane
      set-window-option -g mode-keys vi
      #set-window-optio -g utf8 on
      # look'n feel
      set-option -g status-fg cyan
      set-option -g status-bg black
      set -g pane-active-border-style fg=colour166,bg=default
      set -g window-style fg=colour10,bg=default
      set -g window-active-style fg=colour12,bg=default
      set-option -g history-limit 64096

      set -sg escape-time 10

      #### COLOUR

      color_status_text="colour245"
      color_window_off_status_bg="colour238"
      color_light="white" #colour015
      color_dark="colour232" # black= colour232
      color_window_off_status_current_bg="colour254"

      # default statusbar colors
      set-option -g status-style bg=colour235,fg=colour136,default

      # default window title colors
      set-window-option -g window-status-style fg=colour244,bg=colour234,dim

      # active window title colors
      set-window-option -g window-status-current-style fg=colour166,bg=default,bright

      # pane border
      set-option -g pane-border-style fg=colour235 #base02
      set-option -g pane-active-border-style fg=colour136,bg=colour235

      # message text
      set-option -g message-style bg=colour235,fg=colour166

      # pane number display
      set-option -g display-panes-active-colour colour33 #blue
      set-option -g display-panes-colour colour166 #orange

      # clock
      set-window-option -g clock-mode-colour colour64 #green

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
