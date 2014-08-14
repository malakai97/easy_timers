# EasyTimers

[![Build Status](https://travis-ci.org/malakai97/easy_timers.svg?branch=master)](https://travis-ci.org/malakai97/easy_timers)

A simple interface for creating timers with callbacks that handles all the threading for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_timers'
```

Or install it yourself as:

    $ gem install easy_timers

## Usage

Create a new group of timers with `EasyTimers::Timers.new`:

```ruby
require 'easy_timers'

timers = EasyTimers::Timers.new
```

Schedule a timer to execute 10 seconds from now with `EasyTimers::Timers#after`:

```ruby
timers.after(10) { puts "Hello world" }
```

Now `timers` has a single timer that will call its block in ten seconds.

You can also supply a ruby Time object instead of an interval.

```ruby
the_future = Time.now + 10
timers.after(the_future) { put "Ten seconds have passed." }
```

If you want to be able to cancel a specific timer, you should give it a name:

```ruby
timers.after(60, :one_minute) { puts "It's been 60 seconds." }
# do some work and decide to change our mind
timers.cancel(:one_minute)
```

If you'd rather not mint your own names, one will be generated for you:

```ruby
timer_name = timers.after(10) { puts "hai" }
timers.cancel(timer_name)
```

You can also create periodic timers with `EasyTimers::Timers#every`:

```ruby
timer_name = timers.every(1) { puts "One second has passed." }
```

Periodic timers will be scheduled repeatedly until cancelled.

Need a combination of the above?  You can schedule a period timer to start at
a certain time, then scheduled repeatedly using a different interval:

```ruby
timer_name = timers.after_then_every(0.5, 0.1, :my_timer) { puts "tic toc" }
```

The above timer will first fire after half a second, then fire every 0.1 seconds thereafter.

## Contributing

1. Fork it ( https://github.com/malakai97/easy_timers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
