# EasyTimers

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

You can also supply a ruby DateTime object instead of an interval.

```ruby
the_far_future = DateTime.parse('2027-01-01')
timers.after(the_far_future) { put "We've had great uptime." }
```

If you want to be able to cancel a specific timer, you should give it a name:

```ruby
timers.after('one_minute', 60) { puts "It's been 60 seconds." }
# do some work and decide to change our mind
timers.cancel('one_minute')
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

Periodic timers will continue as long as their block returns true.  This can be used to stop a period timer
once some condition has been met, or you can cancel them with as before.

## Contributing

1. Fork it ( https://github.com/malakai97/easy_timers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
