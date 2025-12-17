{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-b";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set-option -g mouse
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection primary -filter | xclip -selection clipboard"
      set -g mouse on
      set -g default-terminal "screen-256color"
      set -g default-command "zsh"
      set -sg repeat-time 600
      set -g history-limit 5000
      set -g base-index 1
      setw -g pane-base-index 1
      setw -g automatic-rename on
      set -g renumber-windows on
      set -g set-titles on
      set -g display-panes-time 800
      set -g display-time 1000
      set -g status-interval 10
      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history
      set -g monitor-activity on
      set -g visual-activity off
      set-option -g status-style fg=colour219,bg=colour234
      set-window-option -g window-status-style fg=colour234,bg=default
      set-window-option -g window-status-current-style fg=colour219,bg=default
      set-option -g pane-border-style fg=colour234
      set-option -g pane-active-border-style fg=colour219
      set-option -g message-style fg=colour166,bg=colour235
      set-option -g display-panes-active-colour colour219
      set-option -g display-panes-colour colour245
      set-window-option -g clock-mode-colour colour219
      set-window-option -g window-status-bell-style fg=colour235,bg=colour160
      new-session -n $HOST
    '';
  };
}
