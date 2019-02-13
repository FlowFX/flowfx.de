<!--
.. title: Speed up RSpec with bundler standalone and springified binstubs
.. slug: speed-up-rspec-with-bundler-standalone-and-springified-binstubs
.. date: 2019-02-12 13:03:22 UTC+01:00
.. tags: draft
.. category: 
.. link: 
.. description: 
.. type: text
-->

Testing Rails with RSpec is slow, or at least it feels slow to me in all the projects I am working on. Any speed gain helps my productivity when it reduces the time I'm waiting between writing code or test code and running those tests.

There are quite a few posts out there that tackle this problem. But most are pretty old, and none really worked for me, so I'm not going to link to them.

At least, [Faster Test Boot Times with Bundler Standalone](http://myronmars.to/n/dev-blog/2012/03/faster-test-boot-times-with-bundler-standalone) (from 2012) inspired me to look into the `bundler --standalone` command. Not that I really understand what's happening, but at least I got a little bit of a speed bump out of it.

Here's what I did, and how I'm running my tests now.

### Spring
Make sure my Rails is installed with [Spring](https://github.com/rails/spring). This is the default.

Add need this one gem

Gemfile

```ruby
gem 'spring-commands-rspec'
```

```shell
$ bundle install --standalone --path .bundle
```

[Springify binstubs](https://github.com/rails/spring#setup)

```
$ bundle exec spring binstub --all
```


Problem with SQLite 1.4.0, so had to add 

may or may not be related..  I have no idea.


```ruby
group :development, :test do
  gem "sqlite3", "~> 1.3.6"
end
```

do another

```shell
$ bundle install --standalone
```

because..

The vim-test plugin option

[I use vim-test](link://slug/running-rspec-with-a-single-keystroke-in-a-separate-tmux-session)

```vim
let test#ruby#use_spring_binstub = 1
```
