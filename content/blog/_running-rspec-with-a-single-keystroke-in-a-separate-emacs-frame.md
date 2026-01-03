+++
title = "Running RSpec with a single keystroke in a separate Emacs frame"
author = ["Florian Posdziech"]
slug = "running-rspec-with-a-single-keystroke-in-a-separate-emacs-frame"
draft = true
+++

Find it in [my Emacs config](https://codeberg.org/flowfx/emacs.d).

Don't open a new buffer for RSpec if one already exists. Also, don't move the focus.

```elisp
(add-to-list 'display-buffer-alist
         '("\\*rspec-compilation\\*" . (nil (reusable-frames . t) (inhibit-switch-frame . t))))
```

[Running RSpec with a single keystroke in a separate tmux session](/blog/running-rspec-with-a-single-keystroke-in-a-separate-tmux-session)
