+++
title = "Full text RSS feed in Hugo"
author = ["Florian Posdziech"]
date = 2026-01-03
tags = ["hugo"]
categories = ["tech"]
draft = false
+++

Since migrating this site to [`ox-hugo`](https://ox-hugo.scripter.co/) in 2024 its RSS feed only showed a summary of the blog posts — because that's Hugo's default. I very much dislike such truncated feeds and yesterday, finally, I have updated the template for RSS feeds to include the whole post content.

Of course I'm not the only one with this problem. The information on, for example <https://blog.amen6.com/blog/2024/03/hugo-enabling-full-text-rss-feed/> is a bit outdated, though.

The default `rss.xml` is now located at <https://github.com/gohugoio/hugo/blob/master/tpl/tplimpl/embedded/templates/rss.xml> ([Permalink](https://github.com/gohugoio/hugo/blob/b8a2c10d06d815cdaf61ef2f03fb37267612da2e/tpl/tplimpl/embedded/templates/rss.xml)), and it needs to be placed directly inside the `/layouts` directory.

The required change in the file is still the same ([commit](https://github.com/FlowFX/flowfx.de/commit/451b92f20dc43cfcb90ac7c35b62cd1c175975e9)):

```diff
-     <description>{{ .Summary | transform.XMLEscape | safeHTML }}</description>
+     <description>{{ .Content | transform.XMLEscape | safeHTML }}</description>
```

Make sure you run a version of Hugo equal or greater than `v0.146.0` both locally AND in your build CI. I was very confused for a while [until _I_ did](https://github.com/FlowFX/flowfx.de/commit/f54391438aeb171cbe26d0bfb24c84256c437f2f).
