---
title: "How to install a Python virtual environment on macOS"
slug: install-a-python-virtual-environment-on-macos
date: 2017-03-24
taxonomies:
  tags: ["python", " virtualenvwrapper", " macos", " homebrew"]
  categories: 
---


**Update 23/02/2018: don't do this! Do this: [My Python Development Environment, 2018 Edition](https://jacobian.org/writing/python-environment-2018/) by Jacop Kaplan-Moss.**

---

This one is for my amazing designer [Angélica](https://angelica-ramos.com). I should have written it before I failed to install a Python virtual environment on her machine this week.

First of all: trust me, when I tell you that you want to use a virtual environment for your Python work. Second: there are many ways to install and use virtual environments. This one works for me(TM).

## Install homebrew
[Homebrew](https://brew.sh/index_es.html) is a package manager for macOS that allows us to install a current version of Python, e.g. Python 3.6 at the moment. This is what we want.

Start your terminal.app and copy and paste the installation command from the Homebrew website into it. Then hit enter.

## Install Python3
When homebrew is installed, stay in the terminal.app and install Python3 using this command.

    $ brew install python3

Now, the commands `python3` and `pip3` are available on the command line. You can check the installed Python version with

    $ python3 --version
    Python 3.6.0

## Install virtualenvwrapper
Next, use `pip3` to install the virtualenvwrapper tool ([Official documentation](http://virtualenvwrapper.readthedocs.io/en/latest/install.html)) that makes working with virtual environments easy. I don't even know how much easier, because I only ever use virtualenvwrapper.

    $ pip3 install virtualenvwrapper

Open the file `/Users/<your_username>/.bashrc` in your text editor (like SublimeText), and add the following lines at the bottom.

```
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

Quit and reload the terminal.app

## Create a virtual environment
Finally, we can create a virtual environment. Go into our project directory (e.g. `~/code/secret_project/`,

    $ cd code/secret_project/

type into the terminal,

    $ mkvirtualenv --python==python3.6 secret_project

and hit enter. This creates a new virtual environment in

    ~/.virtualenvs/secret_project

## Activate virtual environment
You activate it with

    $ workon secret_project

<!-- Der Clou kommt mit ZSH und dem 'virtualenvwrapper' plugin.

`(venv) ➜  current_directory git:(current_branch)`

