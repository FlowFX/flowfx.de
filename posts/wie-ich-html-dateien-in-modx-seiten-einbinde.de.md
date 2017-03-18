<html><body><p>Durch einen sehr bereichernden Besuch bei <a href="https://twitter.com/cheatha">Cheatha</a> letzte Woche habe ich das grandiose CMS <a href="http://modx.com/">MODX</a> kennengelernt. Es war Liebe auf den ersten Blick.

Ohne zuviel versprechen zu wollen, ahne ich bereits, dass ich hier in Zukunft öfter mal von kleinen feinen MODX-Lösungen berichten werde. Ich fange mit einer an, die mich wirklich schon wochenlang beschäftigt hat.

</p><h3>Das Problem</h3>

Ich arbeite an einem neuen Webprojekt, das <em>sehr</em> viel Content bereithalten wird. Dieser Content wird in Markdown geschrieben und enthält <span class="math">( LaTeX )</span>-Schnipsel. Mittels <a href="http://johnmacfarlane.net/pandoc/">Pandoc</a> übersetze ich diesen Text nach HTML.

Wie bekomme ich dieses HTML nun ohne Copy&amp;Paste in mein MODX?

<!--more-->

<h3>Die Lösung</h3>

Die Antwort kommt - natürlich - in Form eines PHP-Snippets. Klar, mit den entsprechenden PHP-Skills hätte ich das auch einfach selbst schreiben können. Aber die habe ich noch nicht, weswegen ich doch sehr froh über Cheathas Hinweis auf das MODX-Extra <a href="http://modx.com/extras/package/includesnippet">“Include snippet”</a> bin. Ein wenig abgewandelt, an meine aktuellen Pfade angepasst und als <code>includeHTML</code> abgespeichert sieht dies so aus:

<pre><code>&lt;?php
$file = $modx-&gt;getOption('file',$scriptProperties,false);
$snippet = $modx-&gt;getOption('snippet',$scriptProperties,false);
$basePath = $modx-&gt;getOption('base_path');
$includePath = '';

if($file) $includePath = $basePath.$file;
else if($snippet) $includePath = $basePath."assets/elements/btsync/".$snippet.".html";

if(file_exists($includePath)) include($includePath);
else $modx-&gt;log(modX::LOG_LEVEL_ERROR, 'File not found in: '.$includePath, 'HTML', 'snippet/include');
</code></pre>

Warum da <code>btsync</code> drin steht? Weil der Content über einen btsync-Ordner von unseren Heimrechnern auf den Webserver synchronisiert wird. Änderungen können somit immer lokal vorgenommen werden, ohne sich extra in den MODX-Manager einloggen zu müssen.

Um den HTML-Content in eine MODX-Seite einzubinden, reicht nun die folgende Zeile:

<pre><code>[[!includeHTML? &amp;snippet=`dateiname`]]
</code></pre>

Eine Dateiendung ist nicht nötig. Dateien in Unterordnern des Syncordners sind ebenfalls zugänglich. Dazu ist nur der relative Pfad notwendig:

<pre><code>[[!includeHTML? &amp;snippet=`pfad/zur/datei/dateiname`]]
</code></pre>

Ziemlich elegant, wenn ihr mich fragt.</body></html>