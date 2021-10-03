<!--
.. title: Vim and the system clipboard
.. slug: vim-and-the-system-clipboard
.. date: 2021-09-30 08:16:45 UTC+02:00
.. tags:
.. category:
.. link:
.. description:
.. type: text
-->

Vim config of the week: I can now copy & paste between vim and the rest of my system. This has been something I wanted
to have for a long time, and the [Stack Exchange answer](https://vi.stackexchange.com/a/96) sounds like it's standard
stuff. In any case, I am now directly yanking and pasting to and from the system clipboard anytime I use <code>y</code>
or <code>p</code> in Vim.

And all with a simple

```
set clipboard+=unnamedplus
```

in [my vimrc](https://codeberg.org/flowfx/dotfiles/commit/b351a3264961f7d901897c6a29285fd45566f550).
