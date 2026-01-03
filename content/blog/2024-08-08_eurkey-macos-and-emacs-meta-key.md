+++
title = "EurKEY, MacOS and Emacs' Meta key"
author = ["Florian Posdziech"]
date = 2024-08-08
slug = "eurkey-macos-and-emacs-meta-key"
tags = ["emacs", "macos", "keyboard"]
categories = ["tech"]
draft = false
+++

**Back To The Mac 2**

I am building my first [custom Emacs configuration](https://codeberg.org/flowfx/emacs.d), moving away from [Doom Emacs](https://github.com/doomemacs/). Doom was great for getting started with Emacs after using Vim exclusively for the previous... 15 years?!

After the jump [back to the Mac](/blog/emacs-app) there were a number of new issues with my setup that I had no idea how to solve, and there's so much magic happening in Doom that I didn't really want to look too much into it. So I'm taking a step back and starting from scratch. Not really from scratch, because I am using [Emacs Bedrock](https://codeberg.org/ashton314/emacs-bedrock) as a base config. But still.

Reading [Mastering Emacs](https://www.masteringemacs.org/) helped me _a ton_ in finally understanding some core concepts like ... windows, frames, `M-x`, ...

---

Speaking of `M-x`.

One of my most important (tech/productivity) discoveries of the last 10 years is the [EurKEY keyboard layout](#). In short, it let's me use the ANSI/US keyboard layout for programming while also conveniently insert Umlauts and other accented characters. During my work day I mostly write in English and Ruby. Other times I often write German or Spanish. EurKEY let's me do all of that very simply and in similar fashion in every operating systems I use: MacOS and GNU/Linux.

EurKEY requires the use of the Mac's `option` key. Emacs also likes the `option` key. It's called `Meta` there and is used in the most important command: `Meta-x`. If Emacs uses `option` for `Meta`, then it's not forwarded to MacOS to be used in EurKEY.

The solution? Disable the `option` key and only re-enable the _right_ `option` key to act as `Meta`.

```elisp
(setq mac-option-modifier 'none)
(setq mac-right-option-modifier 'meta)
```

This way I can use **the right option key** for Emacs and the left one to write Umlauts.
