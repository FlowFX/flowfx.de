---
title: YouTube channel RSS feeds
taxonomies:
  tags:
    - rss
    - youtube
---

For mostly unknown reasons I want to delete my Google account at some point in the future. The Google services that I am regularly using are Search, Maps, and - increasingly - YouTube. The latter is the only service that really benefits from an account that remembers subscriptions, lists and the history of watched videos.

What I _will_ continue to use are RSS readers. And it turns out that you can (still) subscribe to YouTube channels via their RSS feeds. [Reddit is your friend](https://www.reddit.com/r/privacy/comments/7meku7/alternative_to_youtube_account_youtube_rss/) and provides the answers:

The URL for a channel's RSS feed is

```
https://www.youtube.com/feeds/videos.xml?channel_id= + channel_id
```

where the channel ID can be found in the html source of the channel page or may even be part of the channel URL. In any case, I now subscribe to my YouTube channels via boring, old RSS feeds.

**Update 2020-10-15:** My very good friend [Zeitschlag](https://bullenscheisse.de/) tells me that for those channels that do not have set a custom URL, it's enough to just use the channel URL.

For example, Fat Freddy's Drop - the world's very best band btw. - has the channel URL `https://www.youtube.com/channel/UCsLGIbOjsV8TFTco9cL6HHA`. Those random characters at the end is the channel ID. When I add this URL to my [FreshRSS](https://freshrss.org/) instance, it finds the RSS feed no problem.

In the case of the hip, young, cool YouTubers like Armen Hammer at `https://www.youtube.com/c/ArmenHammerTV`, the channel URL doesn't include this ID but a custom name/slug/identifier. Here, you'll have to go the tedious way as described above.
