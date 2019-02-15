<!--
.. title: Speeding up RSpec with bundler standalone and springified binstubs
.. slug: speeding-up-rspec-with-bundler-standalone-and-springified-binstubs
.. date: 2019-02-14 8:03:22 UTC+01:00
.. tags: rspec, rails, testing, bundler, vim, spring
.. category: 
.. link: 
.. description: 
.. type: text
-->

Testing Rails with RSpec is slow, or at least it feels slow to me in all the
projects I am working on. Any speed gain helps my productivity when it reduces
the time I'm waiting between writing code and running tests.

There are quite a few posts out there that tackle this problem. But most are pretty old, and none really worked for me, so I'm not going to link to them.

[The book I'm reading](https://www.amazon.de/Effective-Testing-RSpec-Build-Confidence/dp/1680501984) inspired me to look into the `bundler --standalone` command. Not that I really understand what's happening there, but at least I got a little bit of a speed bump out of it.

Here's what I did, and how I'm running my tests now.

## Spring
First I made sure my Rails app is installed with [Spring](https://github.com/rails/spring) enabled. Luckily, this is the default. In order to later run RSpec from spring, I added the [spring-commands-rspec](https://github.com/jonleighton/spring-commands-rspec) gem to my Gemfile.

```ruby
gem 'spring-commands-rspec'
```

## Bundler
Next, I used bundler's standalone command,

```bash
$ bundle install --standalone --path .bundle
```

and then ["springified" the installed binstubs](https://github.com/rails/spring#setup).

```bash
$ bundle exec spring binstub --all
```

## Problems
I encountered a problem with SQLite 1.4.0. I didn't investigate it further, but pinned the gem to version 1.3 instead.

```ruby
group :development, :test do
  gem "sqlite3", "~> 1.3.6"
end
```

Afterwards I repeated the install command.

```bash
$ bundle install --standalone --path .bundle
```

Anytime you want to use `bundle install`, you now have to use `bundle install --standalone` instead. I created the bash alias `bis` for that.

## vim-test
I recently started [using the vim-test](link://slug/running-rspec-with-a-single-keystroke-in-a-separate-tmux-session) plugin. That plugin has a neat option that makes it use the springified binstubs.


```vim
" .vimrc

let test#ruby#use_spring_binstub = 1
```

Now, when I'm editing `app/models/transformer_spec.rb` and I hit the return key in normal mode, `vim-test` executes

```shell
$ ./bin/spring rspec spec/models/transformer_spec.rb
```

Because of spring, everything's faster and I have actually seen tests being executed in less than a second. Still not super fast but better than before.
