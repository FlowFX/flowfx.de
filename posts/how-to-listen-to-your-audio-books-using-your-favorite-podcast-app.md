<!--
.. title: How to listen to your audio books using your favorite podcast app
.. slug: how-to-listen-to-your-audio-books-using-your-favorite-podcast-app
.. date: 2018-03-18 15:48:19 UTC-06:00
.. tags: backup, podcast, books
.. category: 
.. link: 
.. description: 
.. type: text
-->

This post talks about two things:

1. how to save backup copies of your Audible audio books
2. how to create an podcast feed of your audio books

**Update 2018-05-27: Audible stopped offering to download the audio files in "Format 4". There are solutions out there, but I haven't gotten around to studying them, yet.**

**Update 2018-05-29: The solution is on GitHub and is called [KrumpetPirate/AAXtoMP3](https://github.com/KrumpetPirate/AAXtoMP3). Thanks to [@igami@social.tchncs.de](https://social.tchncs.de/@igami/100110445500880332) for the tipp!**

## Why?

I buy all ebooks from the Amazon Kindle store, because I know I can save a backup copy of each book in a non-DRM format. This is not about sharing ebooks but rather about making sure that I can keep a copy of my books in a digital format that I will be able to read in the future, too. Also, I want to be able to use any ebook reading app or device I want to, not just Amazon's Kindle apps. Incidentally, I read most of my ebooks on a Kindle Paperwhite because it's just a great device. I sync the books via the Calibre app, though, and the Kindle device is not registered with my Amazon account.

Anyways.

I want the same for my for [Audible](https://www.audible.de/) books. I love audio books, but I hate that I have to rely on the Audible app, with no protection against someone closing down my Amazon account or what not. Turns out, there is a way to do that, without even removing any DRM, because, apparently, there is no DRM on these files.

## How to backup your Audible books

Creating a backup mp3 of audible books is surprisingly simple. Thanks to [@octotherp](https://chaos.social/@octotherp) for [this tipp](https://chaos.social/@octotherp/99688008980687106/)!

<iframe src="https://chaos.social/@octotherp/99688008980687106/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400"></iframe><script src="https://chaos.social/embed.js" async="async"></script>

1. Go to [your Audible library](https://www.audible.de/lib).
2. In the upper right hand corner, select "Format 4" as the download audio format.
3. Use ffmpeg to convert the downloaded files to mp3.

To convert a single audio book, the shell command is:

    $  ffmpeg -i IAmABook.aa -codec copy IAmABook.mp3

To convert all downloaded audio files, use a shell for loop:

    $ for file in *.aa; do ffmpeg -i "$file" -codec copy "${file/%aa/mp3}"; done

This converts all files with the extension `.aa` and renames them with the extension `.mp3`.

## How to create a podcast feed of your audio books
To create a podcast (RSS) feed from a collection of mp3s is surprisingly easy, too. Because others have solved the problem for us.

I'm using the PHP script [DirCaster](http://www.dircaster.org/) and my shared hosting account at my favorite web host [DreamHost](https://www.dreamhost.com/hosting/shared/).

Download and unzip DirCaster in a directory

```bash
    $ wget http://dircaster.org/DirCasterV09k.zip
    $ mkdir audiobooks
    $ cd audiobooks
    $ unzip ../DirCasterV09k.zip
```

Edit `config_inc.php` to set the title and description of the feed. I also add a feed image:

```php
$rssImageUrlTAG   = "https://myaudiobookfeed.com/books.png";
```

To keep thinks neat, I put the mp3 files into a subfolder `books` and edit the `config_inc.php` accordingly:

```php
$mediaDir = "./books"
```

The `audiobooks` directory now has to be served by a web server. A simple one that runs PHP is enough though. I put my feed at a random subdomain that no-one is going to find by accident.

At least my favorite podcast app [Pocket Casts](https://play.pocketcasts.com/) has no problem subscribing to it. I also tried adding password protection using HTTP auth, but that didn't work.


If you have questions about any of this, please [send me a message](link://slug/contact). 

