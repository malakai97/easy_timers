require 'time'

module EasyTimers

  # Wraps a timer
  class Timer
    attr_reader :time, :name, :interval, :recurring, :callback

    # Create a new instance
    # @param time [Float] Seconds since epoch.
    # @param name [Symbol] A name for this timer; generated from the current clock time if nil.
    # @param interval [Float] Seconds.
    # @param recurring [Boolean]
    # @param callback [Callable]
    def initialize(time, name, interval, recurring, callback)
      @time = time
      @name = name
      @interval = interval
      @recurring = recurring
      @callback = callback
      @cancelled = false

      if @name == nil
        @name = Time.now.gmtime.to_f.to_s.to_sym
      end
    end


    # Cancel the timer by overwriting the callback
    def cancel()
      @callback = Proc.new()
      @cancelled = true
    end


    # Check if this timer has been cancelled.
    def cancelled?
      return @cancelled
    end

  end
end

