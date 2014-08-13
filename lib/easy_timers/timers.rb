require 'easy_timers/timer'
require 'easy_timers/group'
require 'date'
require 'time'

module EasyTimers
  class Timers

    # Create a new Timers instance to hold our timers.
    # @return [Timers]
    def initialize()
      @group = Group.new()
    end


    # @overload after(time, name = nil, &block)
    #   Schedule a block to be called immediately after the specified time.
    #   @param time [Time] A time to fire the callback.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    # @overload after(seconds, name = nil, &block)
    #   Schedule a block to be called after the given number of seconds.
    #   @param seconds [Float] Number of seconds to wait before firing the callback.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    def after(time, name = nil, &block)
      if time.is_a?(Time)
        time = time.gmtime.to_f
      elsif time.is_a?(Numeric)
        time = Time.now.gmtime.to_f + time.to_f
      else
        raise ArgumentError, "Invalid arguments to method."
      end

      timer = Timer.new(time, name, 0, false, block)
      name = @group.insert(timer)
      return name
    end


    # Schedule a block to fire every given amount of seconds
    # @param seconds [Float,Fixnum] Number of seconds to wait before firing the callback,
    #   and the interval between subsequent events.
    # @param name [Symbol] An optional name for the timer.
    #   Will be generated if not provided.
    # @return [Symbol] The name of the timer.
    def every(seconds, name = nil, &block)
      if seconds <= 0 # zero disallowed because you can't run it every 0 seconds.
        raise ArgumentError, "Interval must be greater than 0."
      end
      interval = seconds.to_f
      time = Time.now.gmtime.to_f + interval
      timer = Timer.new(time, name, interval, true, block)
      name = @group.insert(timer)
      return name
    end


    # @overload after_then_every(start_date, interval, name = nil, &block)
    #   Schedule a recurring timer that will first fire after the given time.
    #   @param start_date [Time] A time to first fire the callback
    #   @param interval [Float,Fixnum] Number of seconds to delay after the callback returns.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    # @overload after_then_every(start_seconds, interval, name = nil, &block)
    #   Schedule a recurring timer that will first fire after the given time.
    #   The timer will then be rescheduled every interval.
    #   @param start_seconds [Float,Fixnum] Number of seconds to delay before firing the
    #     first callback.
    #   @param interval [Float,Fixnum] Number of seconds to delay after the callback returns.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    def after_then_every(start, interval, name = nil, &block)

      if start.is_a?(Time) && interval.is_a?(Numeric) && block_given?
        time = start.gmtime.to_f
      elsif start.is_a?(Numeric) && interval.is_a?(Numeric) && block_given?
        time = Time.now.gmtime.to_f + start.to_f
      else
        raise ArgumentError, "Invalid arguments."
      end

      timer = Timer.new(time, name, interval.to_f, true, block)
      name = @group.insert(timer)
      return name
    end


    # Cancel a timer.
    def cancel(name)
      @group.delete(name)
    end

  end
end