require 'easy_timers/timer'

module EasyTimers

  # Maintains a list of timers.
  class Group

    GRANULARITY = 1000 # milliseconds

    # Create a new instance and begin the loop
    def initialize
      @events = []
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
      time = self.get_current_time + (timer.time * (GRANULARITY / timer.granularity))
      interval = timer.interval * (GRANULARITY / timer.granularity)

      normalizedTimer = timer.new(time, timer.name, interval, timer.recurring, GRANULARITY, timer.callback)

      index = @events.index do |element|
        normalizedTimer.time <= element.time
      end

      @events.insert(index, normalizedTimer)
      @names[normalizedTimer.name] = normalizedTimer
      @looping_thread.run()
    end


    # Perform a single loop.
    def loop()
      time = self.get_current_time()

      while @events.first.time <= time
        timer = @events.pop
        Thread.new do
          result = timer.callback.call
          if result && timer.recurring
            newTime = timer.time + timer.interval
            newTimer = Timer.new(newTime, timer.name, timer.interval, timer.recurring, timer.granularity, timer.callback)
            self.insert(newTimer)
          end
        end
      end

      untilNext = @events.first.time - time
      if untilNext < 0
        untilNext = 0
      end
      sleep untilNext
    end


    # Return the current time in milliseconds.
    def get_current_time()
      return  Time.now.gmtime.to_f * self.granularity
    end


  end
end