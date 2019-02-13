<!--
.. title: Teach vim-rails about request specs
.. slug: teach-vim-rails-about-request-specs
.. date: 2019-02-13 18:23:57 UTC+01:00
.. tags: rails, rspec, vim
.. category: 
.. link: 
.. description: 
.. type: text
-->

Slowly but surely I'm getting to know the really interesting Rails-related Vim
plugins.  First and foremost: [vim-rails](https://github.com/tpope/vim-rails).
A new feature that I started using recently is the `:A` **alternate file**
command.  Basically, this makes it super quick to jump from a model file to its model spec file. Or from a controller to its spec.

Since Rails 5.?, controller specs have fallen out of DHH's favor. We now use **request specs**. Unfortunately, `vim-rails` doesn't know about request specs. Fortunately, we can tell it about them.

`vim-rails` is very well documented, and `:help rails-projections` provides the solution to this problem. This is what I put in my `.vimrc`, and now `:A` jumps between my controller files and the related request specs.

```vim
let g:rails_projections = {
      \ "app/controllers/*_controller.rb": {
      \   "test": [
      \     "spec/controllers/{}_controller_spec.rb",
      \     "spec/requests/{}_spec.rb"
      \   ],
      \ },
      \ "spec/requests/*_spec.rb": {
      \   "alternate": [
      \     "app/controllers/{}_controller.rb",
      \   ],
      \ }}
```
