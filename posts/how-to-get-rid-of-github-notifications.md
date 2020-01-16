<!--
.. title: How to get rid of GitHub notifications
.. slug: how-to-get-rid-of-github-notifications
.. date: 2020-01-16 18:39:29 UTC+01:00
.. tags: github, notifications, ublock origin
.. category: 
.. link: 
.. description: 
.. type: text
-->

I don't like notifications. I've minimized the number of notifications I receive on my phone to basically: direct messages, and phone calls from my wife. I also don't like notifications on my desktop system. I've turned everything off on every system I use.

But there's one place that I visit constantly, every day, every hour, where I couldn't get rid of the tiny blue dot that indicates that something changed, someone commented, or something new has to be reviewed. And that's GitHub.

During my last vacation, I logged out of GitHub on all systems, just to avoid seeing that blue dot telling me that my colleagues at work are busy saving the world. I didn't do any programming during that time, but I still had to visit GitHub sometimes!

Anyways. [The internet](https://mastodon.social/@l3viathan/103480435257611605), of course, has a solution. Using [uBlock Origin](https://addons.mozilla.org/de/firefox/addon/ublock-origin/), I can remove only the tiny blue notifications indicator from my github.com. It's something like "right click >> block element >> select the blue dot".

In the uBlock settings under "My filters" there's now this entry:


```Bash
! 1/15/2020 https://github.com
github.com##.unread.mail-status
```

which solves all my problems. :D
