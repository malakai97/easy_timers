require 'easy_timers/timer_command'
require 'easy_timers/group'

module EasyTimers
  class Timers

    # Create a new Timers instance to hold our timers.
    # @return [Timers]
    def initialize()
      @group = Group.new()
    end


    # @overload after(time, name = nil, &block)
    #   Schedule a block to be called immediately after the specified time.
    #   @param time [DateTime]
    #   @param name [String,Symbol] An optional name for the timer.
    #     Will be generated if not provided.
    #   @return [String,Symbol] The name of the timer.  Note that
    #     automatically generated names will always be symbols.
    # @overload after(seconds, name = nil, &block)
    #   Schedule a block to be called after the given number of seconds.
    #   @param seconds [Fixnum] Number of seconds to wait before
    def after(time, name = nil, &block)

    end
  end
end