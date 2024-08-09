---
title: "Unit testing and test parametrization with RSpec?"
slug: unit-testing-and-test-parametrization-with-rspec
date: 2019-01-27
taxonomies:
  tags: ["rspec", " pytest", " testing", " ruby"]
  categories: 
---


Last year I made the switch from developing with Python and Django to working with Ruby and Rails. With that, I also had to learn a new test runner. No more [pytest](https://docs.pytest.org/en/latest/) :(.

For some reason, a very popular test runner for testing Rails apps is [RSpec](https://rspec.info/). Its domain-specific language (DSL) is written with Behavior Driven Development in mind. Hence its tag line:

> Behaviour Driven Development for Ruby.
> Making TDD Productive and Fun.

I'm really struggling with using RSpec, and I wonder why. Most of the time, I'm fighting the framework instead of enjoying its benefits. So I want to explore these questions and hopefully get some answers how to do this better. This is the first post on this topic.

## Testing simple functions

Let's take a simple function that adds two numbers. 

```python
# Python
def add(a, b):
    return a + b
```

```ruby
# Ruby
def add(a, b)
  a + b
end
```

Using pytest, it takes 2 lines of code to test this function with one set of parameters.

```python
def test_add():
    assert add(5, 4) == 9
```

Using RSpec, this takes me at least 5 loc.

```ruby
describe '#add' do
  it 'returns the sum of 2 integers' do
    expect(add(5, 4)).to eq(9)
  end
end
```

Or 4 if I use the `subject` shorthand notation.

```ruby
describe '#add' do
  subject { add(5, 4) }

  it { is_expected.to eq 9 }
end
```

That's *a lot* of words for just a simple assertion.

## Test parametrization

Now I want to test not only one set of test parameters, but many. With pytest I use the parametrize marker.

```python
import pytest

@pytest.mark.parametrize("a, b, expected", [
    (5, 4, 9),
    (1, 2, 3),
    (1, 2, 4)
])
def test_add(a, b, expected):
    assert add(a, b) == expected
```

In case of a test failure, pytest shows me exactly which parameters lead to the error.

```bash
======== FAILURES =========
________ test_add[1-2-4] ______

a = 1, b = 2, expected = 4

    @pytest.mark.parametrize("a, b, expected", [
        (5, 4, 9),
        (1, 2, 4)
    ])
    def test_add(a, b, expected):
>       assert add(a, b) == expected
E       assert 3 == 4
E        +  where 3 = add(1, 2)
```

### RSpec 1

A naïve Ruby implementation would be to loop over an array of parameter arrays.

```ruby
params = [
  [5, 4, 9],
  [1, 2, 3],
  [1, 2, 4]
]

describe '#add' do
  params.each do |p|
    it 'returns the sum of 2 integers' do
      expect(add(p[0], p[1])).to eq(p[2])
    end
  end
end
```

Failure output is not very helpful as I don't see which parameters caused the error.

```ruby
Failures:

  1) #add returns the sum of 2 integers
     Failure/Error: expect(add(p[0], p[1])).to eq(p[2])

       expected: 4
            got: 3

       (compared using ==)
     # ./demo02_spec.rb:16:in `block (3 levels) in <top (required)>'
```

### RSpec 2

Another approach, that I found on the internets, includes writing a test function and call that function repeatedly using different parameters.

```ruby

def test_add(a, b, expected)
  describe '#add' do
    subject { add(a, b) }

    it { is_expected.to eq expected }
  end
end

test_add 5, 4, 9
test_add 1, 2, 3
test_add 1, 2, 4
```

The test function looks a little obscure, but the last part is very readable. Also, when a failure occurs, we can see the exact line where it happens.

```ruby
Failures:

  1) #add should eq 4
     Failure/Error: it { is_expected.to eq expected }

       expected: 4
            got: 3

       (compared using ==)
     # ./demo03_spec.rb:12:in `block (2 levels) in test_add'
```


### rspec-parametrized

Lastly, there is the [rspec-parameterized](https://github.com/tomykaira/rspec-parameterized) plugin that provides a syntax that's very close to pytest.

```ruby
require 'rspec-parameterized'

describe '#add' do
  where(:a, :b, :expected) do
    [
      [4, 5, 9],
      [1, 2, 3],
      [1, 2, 4]
    ]
  end

  with_them do
    it 'returns the sum of 2 integers' do
      expect(add(a, b)).to eq expected
    end
  end
end
```

Failure output is actually helpful, even if not as clean as pytest:

```ruby
Failures:

  1) #add a: 1, b: 2, expected: 4 returns the sum of 2 integers
     Failure/Error: expect(add(a, b)).to eq expected

       expected: 4
            got: 3

       (compared using ==)
     # ./demo05_spec.rb:20:in `block (3 levels) in <top (required)>'
```

The reason we have not yet introduced this plugin into our test suite at work is that the gem has a few dependencies that have not been updated in *many* years:

- `abstract_type`, current version: 0.0.7 (2013)
- `adamantium` 0.2.0 (2014)
- `concord` 0.1.5 (2014)
- `proc_to_ast` 0.1.0 (2015)


## Conclusion?
All-in-all, I am still very confused about how to best use RSpec. Testing simple functions includes *a lot* of boilerplate code that's hard to write and slow to read. Test parameterization is doable but no clear best practice has emerged, yet.

If you can help me out and give me some pointers, or if you can tell me that I'm going at this completely wrong, please mention me on [Mastodon](https://chaos.social/@flowfx/) (preferred) or [Twitter](https://twitter.com/flowfx_) or [contact me another way](/contact).

Possible future questions include:

- [Property-based testing](https://hypothesis.works/articles/what-is-property-based-testing/)
- GIVEN-WHEN-THEN
- Utilizing `--format documentation`
- `FactoryBot.create` vs. `FactoryBot.build`
