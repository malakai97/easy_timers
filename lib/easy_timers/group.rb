require 'easy_timers/timer'

module EasyTimers

  # Maintains a list of timers.
  class Group

    GRANULARITY = 1000 # milliseconds

    # Create a new instance and begin the loop
    def initialize
      @handles = []
      @names = Hash.new do |hash,key|
        hash[key] = []
      end
      @looping_thread = Thread.new() do
        while true
          self.loop()
        end
      end
    end


    # Insert a new timer_command into the group
    # @param timer [Timer]
    def insert(timer)
      if timer.granularity != GRANULARITY
        time = timer.time * (GRANULARITY / timer.granularity)
        interval = timer.interval * (GRANULARITY / timer.granularity)
      end

      time =  self.get_current_time + (timer.interval * self.granularity)
      interval = timer.interval * self.granularity
      handle = #Handle.new(time, name, interval, recurring, callback)
      self.insert_handle(handle)
    end


    # Insert a handle into the group
    def insert_handle(handle)
      index = @handles.index do |element|
        handle.time <= element.time
      end

      @handles.insert(index, handle)
      @names[handle.name] = handle
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
            self.insert_handle(handle)
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