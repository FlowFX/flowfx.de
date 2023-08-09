---
title: "List comprehensions for physicists"
slug: list-comprehensions-for-physicists
date: 2016-11-25
taxonomies:
  tags: ["python"]
  categories: 
---


> A list comprehension provides a compact way of mapping a list to another list by applying a function to each of the elements of the list.
>
> – <cite>From "Dive Into Python 3"</cite>

Yeah. Well. Talk English to me! Please.

Until recently I had no clue what list comprehensions do or how to use them or what they're good for. Reading [Dive Into Python 3](http://www.diveintopython3.net/) about two years ago, without much prior programming knowledge, maybe wasn't the best idea I ever had.

Today I know quite a bit more about programming in general and about Python in particular. Still, list comprehensions kept eluding me until I read [From List Comprehensions to Generator Expressions](https://python-history.blogspot.mx/2010/06/from-list-comprehensions-to-generator.html) by the inventor of Python himself, Guido van Rossum.

In this article, he starts by showing how lists are stated in mathematics. As a physicist, an expression like

$$ \\{ x \in \mathbf{N}\ |\ x < 10 \\} $$

is perfectly clear to me. It's the set of all natural numbers that are smaller than 10, i.e.:

$$ \\{1, 2, 3, 4, 5, 6, 7, 8, 9\\} $$

depending on your preference of zero being a natural number or not.

A python list of these integers would be:

```python
[0,1,2,3,4,5,6,7,8,9]
```

Und suddenly, everything became clear to me.

```python
[f(x) for x in S if P(x)]
```

is the list of the function values $f(x)$ of all $x$ in the set $\mathbf{S}$ that fulfill the condition $\mathbf{P}$.

Using a Python list comprehension, the first mathematical expression above reads:

```python
[x for x in N if x < 10]
```

Of course, this list is not possible, because $\mathbf{N}$ is infinite.

The function value $f(x)$ is very handy as well. The set of the squares of all integers between 1 and 4:

$$ \\{ y\ |\ y = x^{2}; x \in \mathbf{N}; 0 < x < 5 \\} $$

expressed via a list comprehension is:

```python
[x**2 for x in [1,2,3,4]]
```

Looking at list comprehensions in mathematical terms helped me understand them. It's a great example of one and the same idea expressed differently in different fields and thus more or less understandable by people in that field.