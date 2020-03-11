<!--
.. title: Better Anki Learning Steps
.. slug: better-anki-learning-steps
.. date: 2019-06-23 16:16:52 UTC+02:00
.. tags: anki, learning
.. category: 
.. link: 
.. description: 
.. type: text
-->

I've been playing around with [Anki](https://apps.ankiweb.net/), the [spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition) application, A LOT in the last few weeks. This will certainly not be the last post about Anki, but I'll start with a simple reference post for me to remember where I learned **how Anki's learning steps work**. 

Check out this video:

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/1XaJjbCSXT0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

It explains

1. the different **types** of cards in Anki,
2. how learning **intervals** are **calculated**,
3. what the **ease** and **interval modifiers** are,
4. what the **ease factor** is, and
5. how **answers modify** the interval.

It also talks in depth about "Ease Hell", what it is, and how to avoid it.

Now I finally understand what Anki's Learning Phase is all about ([12:34](https://youtu.be/1XaJjbCSXT0?t=753)), and how to best use it. Money quote:

> Answering a card incorrectly in the learning phase does not change its ease factor.

The proposed settings for the Learning Phase are:

- Steps (minutes): 15 1440 8640
- Graduating Interval (days): 15

These numbers are based on the SuperMemo 2 algorithm ([18:34](https://youtu.be/1XaJjbCSXT0?t=1134)), which is what Anki is actually using, just not with sane default. Watch the whole video for more details. It's worth it!
