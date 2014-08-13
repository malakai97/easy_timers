module EasyTimers

  # Wraps a timer
  class Timer
    attr_reader :time, :name, :interval, :recurring, :granularity, :callback

    # Create a new instance
    # @param time [Float]
    # @param name [Symbol]
    # @param interval [Float]
    # @param recurring [Boolean]
    # @param callback [Callable]
    def initialize(time, name, interval, recurring, granularity, callback)
      @time = time
      @name = name
      @interval = interval
      @recurring = recurring
      @granularity = granularity
      @callback = callback
      @cancelled = false
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

