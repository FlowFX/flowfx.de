---
title: "Install an extra LaTeX font package on PythonAnywhere"
slug: install-an-extra-latex-font-package-on-pythonanywhere
date: 2017-06-09
taxonomies:
  tags: ["python", " latex", " roboto", " pythonanywhere", " texlive"]
  categories: 
---


This week I installed a LaTeX font package in my [PythonAnywhere](https://www.pythonanywhere.com/) account. [The TL;DR](#tldr): just install it manually.

<hr>
I've been using LaTeX on and off for more than 10 years now. But  I never dove into the depths of the system, typesetting mathematical expressions was fun enough for me.

So I rely on Google a good bit. But that's fine, as there are always new things to discover. Plus: the PythonAnywere support is superb! I had a very helpful email exchange with Giles. Thanks!

Using the TeXLive distribution on my Mac, and on the Ubuntu server that runs PythonAnywhere, the way to install packages nowadays is to use the `tlmgr` command, which I can only assume to be an abbreviation for *TeX Live manager*.

```
$ tlmgr install roboto
```

Well, that didn't work, because I am not root nor sudo. Turns out, [there is a tlmgr User Mode](https://tex.stackexchange.com/questions/288545/installing-with-tlmgr-without-sudo-to-texmf/288639#288639) which, after initializing a local user tree

```
$ tlmgr init-usertree
```

allows me to install additional LaTeX packages into my home directory under `~/texmf`. So:

```
$ tlmgr --usermode install roboto
```

should have done it. Unfortunately I got the following error message.

```
$ tlmgr --usermode install roboto
/usr/bin/tlmgr: could not find a usable xzdec.
/usr/bin/tlmgr: Please install xzdec and try again.
```

Thanks to Giles, it was easy to install the missing `xz` package.

```
$ wget https://tukaani.org/xz/xz-5.2.3.tar.gz
$ tar xf xz-5.2.3.tar.gz 
$ cd xz-5.2.3/
$ ./configure --prefix=$HOME/.local
$ make
$ make install
```

That actually worked. But then `tlmgr` spit out this:

```
Unknown directive ...containerchecksum
06c8c1fff8b025f6f55f8629af6e41a6dd695e13bbdfe8b78b678e9cb0cfa509826355f4ece20d8a99b49bcee3c5931b8d766f0fc3dae0d6a645303d487600b0..., please fix it! at /usr/share/texlive/tlpkg/TeXLive/TLPOBJ.pm line 210, <$retfh> line 5761.
```

This is a clear case for Google, and Google didn't disappoint. The installed version of Tex Live is from 2013 and doesn't work with the current package repositories.

```
$ tlmgr --version
(running on Debian, switching to user mode!)
tlmgr revision 32912 (2014-02-08 00:49:53 +0100)
tlmgr using installation: /usr/share/texlive
TeX Live (http://tug.org/texlive) version 2013
```

After setting the repository to an old archived one,

```
$ tlmgr option repository ftp://tug.org/historic/systems/texlive/2013/tlnet-final
```

the TeX Live installation was happy.

But, it turns out, the 2013 repository doesn't even include the `roboto` font package. So…

<a name="tldr"></a>
### TL;DR
… in the end, I installed the font by hand,
following the instructions here:
[http://www.ctan.org/tex-archive/fonts/roboto/](http://www.ctan.org/tex-archive/fonts/roboto/).

```
$ wget http://mirror.ctan.org/install/fonts/roboto.tds.zip
$ cd ~/texmf
$ unzip ~/roboto.tds.zip
$ texhash
$ updmap --enable Map=roboto.map
```

And now I have the `roboto` font available for pdflatex on [PythonAnywhere](https://www.pythonanywhere.com/)!