<!--
.. title: Copy & paste from tmux to system clipboard
.. slug: copy-paste-from-tmux-to-system-clipboard
.. date: 2020-01-16 18:20:33 UTC+01:00
.. tags: tmux, linux
.. category: 
.. link: 
.. description: 
.. type: text
-->

For the first time in many years I am using a Linux machine for my work. In general I am extremely pleased with the system I've set up. But of course, there are things that don't "just work".

Like... copy selected text from a tmux pane to the clipboard. 

As usual, [StackOverflow](https://unix.stackexchange.com/a/349020) knows the answer. In short:

```Bash
# .tmux.conf
set-option -g mouse on
set-option -s set-clipboard off
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -se c -i"
```
