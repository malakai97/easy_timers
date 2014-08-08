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
    #   @param time [DateTime] A time to fire the callback.
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

    end


    # Schedule a block to fire every given amount of seconds
    # @param seconds [Float] Number of seconds to wait before firing the callback,
    #   and the interval between subsequent events.
    # @param name [Symbol] An optional name for the timer.
    #   Will be generated if not provided.
    # @return [Symbol] The name of the timer.
    def every(seconds, name = nil, &block)

    end


    # @overload after_and_every(start_date, interval, name = nil, &block)
    #   Schedule a recurring timer that will first fire after the given time.
    #   The timer will then be rescheduled after the block returns, unless
    #   the block returns false in which case the timer will be deleted.
    #   @param start_date [DateTime] A time to first fire the callback
    #   @param interval [Float] Number of seconds to delay after the callback returns.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    # @overload after_and_every(start_seconds, interval, name = nil, &block)
    #   Schedule a recurring timer that will first fire after the given time.
    #   The timer will then be rescheduled after the block returns, unless
    #   the block returns false in which case the timer will be deleted.
    #   @param start_seconds [Float] Number of seconds to delay before firing the
    #     first callback.
    #   @param interval [Float] Number of seconds to delay after the callback returns.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    def after_and_every(start, interval, name = nil, &block)

    end


    # @overload after_and_every(start_date, interval, name = nil, &block)
    #   Similar to {#after_and_every}, schedule a block to fire starting
    #   at start_date and repeating every interval.  However, this method does
    #   not wait for the block to return before scheduling the next event.
    #   Timers scheduled this way must be manually deleted.
    #   @param start_date [DateTime] A time to first fire the callback
    #   @param interval [Float] Number of seconds between events.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    # @overload after_and_every(start_seconds, interval, name = nil, &block)
    #   Similar to {#after_and_every}, schedule a block to fire starting
    #   at start_seconds and repeating every interval.  However, this method does
    #   not wait for the block to return before scheduling the next event.
    #   Timers scheduled this way must be manually deleted.
    #   @param start_seconds [Float] Number of seconds to delay before firing the
    #     first callback.
    #   @param interval [Float] Number of seconds between events.
    #   @param name [Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [Symbol] The name of the timer.
    def after_and_metronome(time, interval, name = nil, &block)

    end




    protected
    # Schedule a block to be called immediately after the specified time.
    # @param time [DateTime]
    # @param name [String,Symbol] An required name for the timer.
    # @param callback [Callable]
    def after_date(time, name, callback)
      interval = time.to_time.gmtime.to_f - Time.now.gmtime.to_f
      self.after_seconds(interval, name, callback)
    end


    # Schedule a block to be called after the given number of seconds.
    # @param seconds [Float] Number of seconds to wait before firing.
    # @param name [String,Symbol] An required name for the timer.
    # @param callback [Callable]
    def after_seconds(seconds, name, callback)
      command = TimerCommand.new(seconds, name.to_sym, false, callback)
      @group.insert(command)
    end


    # Schedule a block to be called repeatedly until its result is false
    # @param time [Float] Number of seconds to wait before the first fire.
    # @param interval [Float] Number of seconds between each recurrence.
    # @param name [String,Symbol] An required name for the timer.
    # @param callback [Callable]
    def every_after_seconds(seconds, interval, name, callback)
      command = TimerCommand.new(seconds, name.to_sym, true, callback)
      @group.insert(command)
    end
  end
end