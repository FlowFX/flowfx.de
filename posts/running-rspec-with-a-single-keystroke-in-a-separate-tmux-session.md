<!--
.. title: Running RSpec with a single keystroke in a separate tmux session
.. slug: running-rspec-with-a-single-keystroke-in-a-separate-tmux-session
.. date: 2019-02-11 10:18:10 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
-->

This is a tiny update to [Running Specs from Vim, Sent to tmux via Tslime](https://thoughtbot.com/blog/running-specs-from-vim-sent-to-tmux-via-tslime) from the thoughtbot blog. Go read it, and realize that it's six years old.

[vim-rspec](https://github.com/thoughtbot/vim-rspec) has not been updated in two years. It probably still works fine, but there's a new vim plugin that does what vim-rspec does, just better: [vim-test](https://github.com/janko/vim-test).

I finally set this up yesterday:

```vim
" Add vim-test and tslime to vim plugins.
Plug 'janko/vim-test'
Plug 'jgdavey/tslime.vim'

...

" Configure vim-test to execute test command using tslime
let test#strategy = "tslime"

" Configure <CR> aka the Return key to run my test file.
nmap <CR> :TestFile<CR>
" I'm still figuring out which test commands make the most sense
" in my workflow. Right now, this feels pretty good.
nmap <leader><CR> :TestLast<CR>
```

Now, when I'm in normal mode and hit the return key, rspec gets executed for the current file **in a different tmux pane (!!)**. What I didn't understand before using this was how it would select the correct pane. Turns out, it's super easy. On the first run, it asks me for the tmux session, window, and pane (if necessary). After that, it remembers and it always sends the test command there. Super cool!
