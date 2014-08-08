module EasyTimers

  # Wraps an instruction to create a timer.
  class TimerCommand
    attr_reader :interval, :recurring, :callback

    # Create
    # @param interval [Float] The interval in seconds.
    # @param recurring [Boolean] Whether or not to recur.
    # @param callback [Callable]
    def initialize(interval, recurring, callback)
      @interval = interval
      @recurring = recurring
      @callback = callback
    end
  end
end