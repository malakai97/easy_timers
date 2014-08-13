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
      if time.instance_of?(DateTime)
        seconds = time.to_time.gmtime.to_f - Time.now.gmtime.to_f
      elsif time.instance_of?(Numeric)
        seconds = time.to_f
      else
        raise ArgumentError, "Invalid arguments to method."
      end

      if seconds < 0 # We allow zero for items to be run immediately.
        raise ArgumentError, "Scheduled time is in the past."
      end

      name = self.after_seconds(seconds, name, block)
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
      name = self.after_then_every(seconds.to_f, seconds.to_f, name, &block)
      return name
    end


    # @overload after_then_every(start_date, interval, name = nil, &block)
    #   Schedule a recurring timer that will first fire after the given time.
    #   @param start_date [DateTime] A time to first fire the callback
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

      if start.instance_of?(DateTime) && interval.instance_of?(Numeric) && block_given?
        # after_and_every(start_date, interval, name = nil, &block)
        seconds = time.to_time.gmtime.to_f - Time.now.gmtime.to_f
        name = self.after_then_every_seconds(seconds, interval.to_f, name, block)

      elsif start.instance_of?(Numeric) && interval.instance_of?(Numeric) && block_given?
        # after_and_every(start_seconds, interval, name = nil, &block)
        name = self.after_then_every_seconds(start.to_f, interval.to_f, name, block)

      else
        raise ArgumentError, "Invalid arguments."
      end

      return name
    end


    # Cancel a timer.
    def cancel(name)
      @group.delete(name)
    end


    protected
      # Schedule a block to be called after the given number of seconds.
      # @param seconds [Float] Number of seconds to wait before firing.
      # @param name [String,Symbol] An optional name for the timer.
      # @param callback [Callable]
      # @return [Symbol] The name of the timer.
      def after_seconds(seconds, name, callback)
        command = Timer.new(seconds, name, 0, false, 1, callback)
        name = @group.insert(command)
        return name
      end


      # Schedule a block to be called repeatedly, starting after some time.
      # @param seconds [Float] Number of seconds to wait before the first fire.
      # @param interval [Float] Number of seconds between each recurrence.
      # @param name [String,Symbol] An optional name for the timer.
      # @param callback [Callable]
      # @return [Symbol] The name of the timer.
      def after_then_every_seconds(seconds, interval, name, callback)
        command = Timer.new(seconds, name, interval, true, 1, callback)
        name = @group.insert(command)
        return name
      end
  end
end