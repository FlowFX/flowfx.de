+++
title = "Using Automator to create an Emacs.app for running Emacs Client & Server"
author = ["Florian Posdziech"]
date = 2024-02-11
tags = ["emacs", "macos"]
categories = ["tech"]
draft = false
+++

Or: **Back To The Mac 1**

After using only Linux machines for work for the past 5 years, my next machine will be a MacBook. That's why I'm working on improving my development environment on macOS as best as I can now, something that's not really been necessary when using my personal Mac.

First order of business: how do I start the Emacs server and connect to it with the emacsclient?

I'm using [Emacs+](https://github.com/d12frosted/homebrew-emacs-plus) from homebrew:

```shell
brew install emacs-plus@29
```

Once installed, it works fine, but neither do Spotlight - or Alfred - see any Emacs.app, nor do I know how to start the server or start multiple clients that connect to it.

I found the solution on the blog of one Alex Balgavy: [Setting up Emacs as a daemon on macOS](https://blog.alex.balgavy.eu/setting-up-emacs-as-a-daemon-on-macos/). Then I simplified it for my purposes.

All I needed to do is create a new [Automator](https://support.apple.com/de-de/guide/automator/welcome/mac) document of type _Application_ that runs this shell script:

```shell
export PATH=/opt/homebrew/bin:$PATH
emacsclient -c -a '' >/dev/null 2>&1 &
```

\`-c\` creates a GUI frame, and \`-a ''\` connects to the server named \`''\` - or starts it if it's not already running.

{{< figure src="/images/2024/Automator-Emacs_app.png" >}}

Every time I call **Emacs.app**, I get a new fresh Emacs window, just like I'm used to on my Linux machine that runs the Emacs server from systemd.
