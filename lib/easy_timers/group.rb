require 'easy_timers/timer_command'

module EasyTimers

  # Maintains a list of timers.
  class Group

    # Wraps the callback and all the scheduling information.
    class Handle
      attr_reader :time, :interval, :recurring, :callback
      attr_writer :time

      # Create a new handle
      # @param time [Float]
      # @param interval [Float]
      # @param recurring [Boolean]
      # @param callback [Callable]
      def initialize(time, interval, recurring, callback)
        @time = time
        @interval = interval
        @recurring = recurring
        @callback = callback
      end
    end

    attr_reader :granularity

    # Create a new instance and begin the loop
    def initialize
      @granularity = 1000 #milliseconds
      @handles = []
      @looping_thread = Thread.new() do
        while true
          self.loop()
        end
      end
    end


    # Insert a new timer_command into the group
    # @param timer_command [timer_command]
    def insert(timer_command)
      time =  self.get_current_time + (timer_command.interval * self.granularity)
      handle = Handle.new(time, timer_command.interval * self.granularity, timer_command.recurring, timer_command.callback)
      self.insert(handle)
    end


    # Insert a handle into the group
    def insert_handle(handle)
      index = @handles.index do |element|
        handle.time <= element.time
      end

      @handles.insert(index, handle)
      @looping_thread.run()
    end


    # Perform a single loop.
    def loop()
      time = self.get_current_time()

      while @handles.first.time <= time
        handle = @handles.pop
        Thread.new do
          result = handle.callback.call
          if result && handle.recurring
            handle.time = handle.time + handle.interval
            self.insert(handle)
          end
        end
      end

      duration = @handles.first.time - time
      if duration < 0
        duration = 0
      end
      sleep duration
    end


    # Return the current time in milliseconds.
    def get_current_time()
      return  Time.now.gmtime.to_f * self.granularity
    end


  end
end