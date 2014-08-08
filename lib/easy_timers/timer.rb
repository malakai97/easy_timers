module EasyTimers

  # Wraps a timer
  class Timer
    attr_reader :time, :name, :interval, :recurring, :granularity, :callback
    attr_writer :time

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
    end

  end
end

