+++
title = "Hugo shortcode for embedding PeerTube videos"
author = ["Florian Posdziech"]
date = 2026-01-02
draft = false
+++

So, I have a [PeerTube](/blog/flowfx-music) account now. With videos!! 🤯 Naturally, I want to embed these videos on this - statically generated - website. Just like YouTube, PeerTube offers an `iframe` embed code:

```html
<iframe title="Los Muchachos feat. The Block Ice Horn Section - Guachiman (live at Jos Fritz Café 15 Feb 2025)" width="560" height="315" src="https://makertube.net/videos/embed/rpfGXbCVSu46P2ELUzhSjT" style="border: 0px;" allow="fullscreen" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe>
```

This `iframe` has a static width of `560px` which may be too large for smaller screens. But PeerTube is great and also offers a _Responsive embed_ which looks like this:

```html
<div style="position: relative; padding-top: 56.25%;">
  <iframe title="The Offbeat Service live in der Funzel 13.12.2025" width="100%" height="100%" src="https://makertube.net/videos/embed/rpfGXbCVSu46P2ELUzhSjT" style="border: 0px; position: absolute; inset: 0px;" allow="fullscreen" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe>
</div>
```

Hugo has a built-in shortcode for YouTube videos. It is used this way:

```html
{{ youtube 0815x11 }}
```

Of course, I want the same thing for my PeerTube videos. One big difference between YouTube and PeerTube is that there is only one YouTube, but there are many, many PeerTube servers. In order to be able to add videos from different PeerTube servers, I need the server name as a second argument. But because both my own and  [my band's PeerTube account](https://makertube.net/a/theuplifters/) live on [MakerTube](https://makertube.net/), I set `makertube.net` as the default address. (See [`compare.Default`](https://gohugo.io/functions/compare/default/) in the Hugo docs)

This results in:

```html
{{ $id := (.Get 0) }}
{{ $server := (default "makertube.net" (.Get 1)) }}

<div style="position: relative; padding-top: 56.25%;">
  <iframe title="Play PeerTube video" width="100%" height="100%" src="https://{{ $server }}/videos/embed/{{ $id }}" style="border: 0px; position: absolute; inset: 0px;" allow="fullscreen" sandbox="allow-same-origin allow-scripts allow-popups allow-forms">
  </iframe>
</div>
```

When saved as `/layouts/shortcodes/peertube.html`, I can use it exactly like the YouTube shortcode,

```html
{{ peertube rpfGXbCVSu46P2ELUzhSjT }}
```

or, if I need to, I can additionally change the address of the PeerTube server.

```html
{{ peertube rpfGXbCVSu46P2ELUzhSjT makertube.net }}
```

The result is a responsively embedded video. 🥳

{{< peertube rpfGXbCVSu46P2ELUzhSjT >}}
