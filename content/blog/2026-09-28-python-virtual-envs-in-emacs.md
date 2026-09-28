+++
title = "Python virtual environments in Emacs"
author = ["Florian Posdziech"]
date = 2026-09-28
slug = "python-virtual-envs-in-emacs"
draft = false
+++

I am looking at Python again, specifically I am working through Brian Okken's awesome book [Python Testing with pytest](https://pythontest.com/pytest-book/). I did that the first time 9 years ago when I first learned Django and TDD, and even wrote [a few blog posts](https://flowfx.de/tags/pytest/) about it.

Nowadays my development environment is Emacs, and very quickly I had to answer the question: how do I tell the really good [`emacs-python-pytest`](https://github.com/wbolster/emacs-python-pytest) package where to find the virtual environment for my project. Luckily for me, [Chris Siebenmann recently asked the same question on Mastodon](https://mastodon.social/@cks/117186120032794520) and then [blogged about it](https://utcc.utoronto.ca/~cks/space/blog/python/VenvsAndToolsInEmacs). That's how I knew where to look.

It's all about setting the environment variables `PATH` and `VIRTUAL_ENV_PROMPT`. My solution differs from Chris's only in that I use the [`emacs-direnv`](https://github.com/wbolster/emacs-direnv) package that's already in [my config](https://codeberg.org/flowfx/emacs.d), but I guess `envrc` works just as well.

```elisp
(use-package direnv
  :hook
  (prog-mode . direnv-mode))
```

By checking what `venv/bin/activate` does to `PATH` and `VIRTUAL_ENV_PROMT`, I saw that they have to be set to `/path/to/project/venv/bin:$PATH` and `venv` respectively. A quick stack overflow search gave me a [a one liner](https://stackoverflow.com/a/246128) that returns the path directory of the file that it is run from. I put that into my \`.envrc\`, and now I can use this file in _all_ my Python projects, and Emacs always knows how to run in the correct virtual environment.

```sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export PATH=$SCRIPT_DIR/venv/bin:$PATH
export VIRTUAL_ENV_PROMT=venv
```

Off to more testing fun with pytest!
