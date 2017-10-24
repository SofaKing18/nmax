[![Build Status](https://travis-ci.org/SofaKing18/nmax.svg?branch=master)](https://travis-ci.org/SofaKing18/nmax)

=======

# Nmax
This gem returns N maximum integers from input string or stdin  

number is a sequence from 1 to 1000 digits  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nmax'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nmax

## Usage

ruby

```ruby
require 'nmax'

obj = Nmax::STDReader.new(3) # return 3 max numbers
obj.get_numbers('a33b42c31f-3-4')
obj.max_numbers # => [31, 33, 42]
```

or in console

```bash
cat Example_file.txt | nmax 30  
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SofaKing18/nmax.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
