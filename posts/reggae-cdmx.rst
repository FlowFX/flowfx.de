.. title: Reggae CDMX
.. slug: reggae-cdmx
.. date: 2016-06-05 11:56:56 UTC-05:00
.. tags: kirby, reggae, mexico city
.. type: text
.. status: draft

A couple of months ago I started a new side project: `Reggae CDMX`_. Clearly inspired by the popular but very local website reggae-freiburg.de.vu_, it's a collection of all local events that are related to Reggae, Dub or Ska music and culture.

I'm building this site with the amazing `Kirby CMS`_, and it is a great opportunity for me to learn.

.. _`Reggae CDMX`: https://reggae-cdmx.com
.. _reggae-freiburg.de.vu: http://reggae-freiburg.de.vu
.. _`Kirby CMS`: https://getkirby.com

So what are some things that I have leaned about so far? 

PHP
---
I never intended to learn any PHP, or at least not seriously. Well, that doesn't work if you want to build cool things. 



nginx directive for cachebuster plugin.

Structured data for events.


Kirby: controllers vs pagemodell vs pagemethods
-----------------------------------------------
The author of Kirby himself provides a small `Kirby Cachebuster`_ plugin. The proposed rewrite rules for Nginx did not work for me. So I googled a little bit and realised that the utilized cache busting technique is a standard way of doing this, not just when using Kirby. The Nginx rules that work for me are::

	location ~* (.+)\.(?:\d+)\.(js|css|png|jpg|jpeg|gif)$ {
		try_files $uri $1.$2;
	}



Facebook Instant Articles
-------------------------
asdf



.. _`Kirby Cachebuster`: https://github.com/getkirby/plugins/tree/master/cachebuster