---
title: "Wie geht das eigentlich mit diesem git pull?"
slug: wie-geht-das-eigentlich-mit-diesem-git-pull
date: 2013-02-02
taxonomies:
  tags: ["Technik"]
  categories: 
---

<p>fragt der geschätzte <a href="http://www.alohastone.com/">aloha</a> auf <a href="https://twitter.com/alohastone/status/297477333802160129">Twitter</a>. Hintergrund ist das gerade von <a href="https://twitter.com/tiefpunkt">Tiefpunkt</a> entwickelte Wordpress-Plugin <a href="https://github.com/meintopf/meintopf">mEintopf</a>, dessen Ziel eine selbst gehostete <a href="http://www.soup.io">Suppe</a> ist. Was genau das sein soll erklärt Tiefpunkt selbst <a href="http://tech.tiefpunkt.com/2013/01/your-own-soup-io-an-idea/">hier in seinem Tech-Blog</a>.

Zurück zur Frage:

</p><h3>Wie geht das eigentlich mit diesem git pull?</h3>

Für die Installation des mEintopf-Plugins logge man sich per ssh auf seinem Webserver ein, navigiere in das Plugin-Verzeichnis seiner Wordpress-Installation und erfreue sich an der ersten git-Magie.

<pre><code>~$ cd wordpress/wp-content/plugins/
~/wordpress/wp-content/plugins$ git pull https://github.com/meintopf/meintopf.git
</code></pre>

Um das Plugin zu aktualisieren, was dank Tiefpunkts rasender <a href="https://twitter.com/tiefpunkt/status/297449693372358656">Entwicklungsgeschwindigkeit</a> sehr oft nötig (möglich?) ist, reicht nun ein einfaches git pull im Plugin-Verzeichnis:

<pre><code> ~/wordpress/wp-content/plugins/meintopf$ git pull origin master
</code></pre>

Ein Deaktivieren und Wiederaktivieren des Plugins hilft normalerweise. Das war's dann aber auch schon.