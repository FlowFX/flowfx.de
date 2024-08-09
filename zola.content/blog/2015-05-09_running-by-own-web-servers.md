---
title: Running my own web servers
slug: running-my-own-web-servers
date: 2015-05-09
---

There are excellent [shared web hosting](https://en.wikipedia.org/wiki/Shared_web_hosting_service) providers out there. Personally I prefer and recommend [Uberspace](https://uberspace.de/) and [domainFactory](https://www.df.eu/int/domains/), if you are located in Europe and you speak German, and [DreamHost](https://www.dreamhost.com/), if you are living in North America. But even these are not perfect.

While researching WordPress topics, I constantly noticed mentions of _nginx_, _PHP-FPM_, _APC_ and _memcached_. Also, people are talking about **fast** WordPress site. Like, really fast. I wanted that, too, but a shared hosting provider can’t deliver this. Maybe DreamHost’s [DreamPress](https://www.dreamhost.com/hosting/wordpress/) WordPress hosting service does, but considering the number large of sites I manage, it’s too expensive for me.

So I began researching about how to set up my own web server. Many of the better tutorials I found on [digitalocean.com](https://www.digitalocean.com/community/tutorials/). Only later I discovered that DigitalOcean offers Virtual Private Servers in several data centers around the world for a very good price. And today, I am a happy customer of theirs with VPSs in Frankfurt, Germany and San Francisco, USA – for my German and my Mexican clients respectively.

I will not post a detailed tutorial about how to set up a web server, many others have done this before me. But I’d like to link to all the resources that I found useful. These will give a head start to anyone who wishes to try this herself.

If you find anything that’s stupid, ridiculous or even dangerous, please [drop me a note](/contact)!

<!-- more -->

## Initial server setup

It all starts with setting up, and somewhat securing, a virtual private server “droplet” at DigitalOcean. Because I am most familiar with Debian based GNU/Linux systems and because of the many, many existing tutorials, I choose the [Ubuntu 14.04 LTS](http://www.ubuntu.com/server/) distribution as my server operating system.

- [Initial Server Setup with Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04)
- [Additional Recommended Steps for New Ubuntu 14.04 Servers](https://www.digitalocean.com/community/tutorials/additional-recommended-steps-for-new-ubuntu-14-04-servers)

I update the OpenSSH configuration according to the [Applied Crypto Hardening](https://bettercrypto.org/static/applied-crypto-hardening.pdf) paper from [BetterCrypto.org](https://bettercrypto.org/).

### mosh

Where I work (i.e. Mexico), the internet connection is often unreliable. And as I use [SSH](https://en.wikipedia.org/wiki/Secure_Shell) all the time to do work on the servers, the SSH replacement [mosh](https://mosh.mit.edu/) is invaluable to me.

- [How To Install and Use Mosh on a VPS](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-mosh-on-a-vps)
- [http://wiki.ubuntuusers.de/Mosh](http://wiki.ubuntuusers.de/Mosh)

### Automatic security upgrades

I like my servers to automatically install relevant security updates.

- [Ubuntu automatic updates](https://help.ubuntu.com/lts/serverguide/automatic-updates.html)

### notification emails

I’m sure there must be a better solution, but to enable email notifications I install _sendmail_.

    sudo aptitude install sendmail

## The LEMP stack

The L**E**MP stack differs from the ubiquitous L**A**MP stack in the choice of the web server. Instead of [Apache](https://httpd.apache.org/) there is [nginx](http://nginx.org/).

- [Digitalocean: How To Install Linux, nginx, MySQL, PHP (LEMP) stack on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04)
- [@chrismeller: Configuring and Optimizing PHP-FPM and Nginx on Ubuntu](http://blog.chrismeller.com/configuring-and-optimizing-php-fpm-and-nginx-on-ubuntu-or-debian)

### fastcgi_params

To get PHP-FPM working, I need to add an extra line to the default <code>/etc/nginx/fastcgi_params</code> configuration file, as found in the [nginx wiki](http://wiki.nginx.org/PHPFcgiExample):

    fastcgi_param   SCRIPT_FILENAME         $document_root$fastcgi_script_name;

## APC vs. Zend Opcache

An OpCache caches compiled versions of the PHP scripts that e.g. WordPress runs on. This tremendously speeds up any PHP site. With PHP 5.5 came built-in support for the [Zend Opcache.](https://pecl.php.net/package/ZendOpcache) which effectively renders other solutions, like [APC](https://pecl.php.net/package/APC), obsolete.

To check if the OpCache is running, you can for example use

- [opcache-gui](https://github.com/amnuts/opcache-gui) or
- [OPcache Status](https://github.com/rlerdorf/opcache-status).

### Zend OPCache on Uberspace

To enable the Zend OPCache in an Uberspace shared hosting environment, you only need to specify your PHP version to e.g. 5.6.

- [Select PHP version on Uberspace](https://wiki.uberspace.de/development:php#php-version_einstellen) (German)

## memcached

[memcached](http://memcached.org/) caches database queries, among others. It’s so easy to install, there is no reason not to.

- [Digitalocean: How To Install and Use Memcache on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-memcache-on-ubuntu-14-04)

### memcached and WordPress

The [WP-FFPC](https://wordpress.org/plugins/wp-ffpc/) plugin turns memcached into an in-memory page cache for WordPress.

## PHP pools

For security and possibly performance purposes, php-fpm “pools” separate php users for different web sites running on the same server.

- [How To Optimize Nginx with PHP Pools on an Ubuntu 13.04 VPS](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-with-php-pools-on-an-ubuntu-13-04-vps)

## What’s next

### user permissions

I am still researching and experimenting with the best setup of user permissions on the server itself. I run sites from several users on the same server, so that’s important. I want my clients to have full access to their files, too. But I also won’t offer shared hosting to everybody. So for now, it’s not a big deal.

### my config files

Ideally I would publish all of my configuration files for reference. Maybe I will.

### IPv6

It took me far too long to figure out how to enable [IPv6](https://en.wikipedia.org/wiki/IPv6) support in the nginx configuration. When I know why my current settings work, I’ll write about it.

To check IPv6 availability, I use [ipv6-test.com](http://ipv6-test.com/validate.php).

### Varnish

[Varnish](https://www.varnish-cache.org/) is a caching server that sits in front of the web server. Although I absolutely don’t need this for the sites I manage, I really want to try it out and play with it.

## Conclusion

Many of the sites that I have already moved to my web servers run _a lot_ faster than before, and more reliably as well. Google’s [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) likes them, too. Also, I pay _less_ for my virtual servers than for all the shared hosting accounts.

I am very happy so far.
