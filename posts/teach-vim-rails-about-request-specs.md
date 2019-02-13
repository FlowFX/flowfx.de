<!--
.. title: Teach vim-rails about request specs
.. slug: teach-vim-rails-about-request-specs
.. date: 2019-02-12 15:23:57 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
-->

In his 

```vim
:help rails-projections
```


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
