require 'easy_timers/timer'

module EasyTimers

  # Maintains a list of timers.
  class Group

    GRANULARITY = 1000 # milliseconds

    # Create a new instance and begin the loop
    def initialize
      @events = []  # Maintained in sorted order of furthest-soonest, aka descending order.
      @names = Hash.new do |hash,key| # Each array in descending order.
        hash[key] = []
      end
      @looping_thread = Thread.new() do
        while true
          self.loop()
        end
      end
    end


    # Insert a new timer into the group
    # @param timer [Timer]
    def insert(timer)
      time = self.get_current_time + (timer.time * (GRANULARITY / timer.granularity))
      interval = timer.interval * (GRANULARITY / timer.granularity)
      normalizedTimer = Timer.new(time, timer.name, interval, timer.recurring, GRANULARITY, timer.callback)

      if @events.size == 0
        index = 0
      else
        index = @events.index do |element|
          normalizedTimer.time > element.time
        end
      end

      @events.insert(index, normalizedTimer)
      @names[normalizedTimer.name].push(normalizedTimer)
      @looping_thread.run()
    end


    # Delete a timer from the group.
    # @param name [Symbol]
    def delete(name)
      if @names[name].size() > 0
        @names[name].each do |timer|
          timer.cancel()
        end
        @names.delete(name)
        @looping_thread.run()
      end
    end


    # Perform a single loop.
    def loop()
      time = self.get_current_time()

      while @events.first.time <= time
        timer = @events.pop
        @names[timer.name].pop
        if timer.cancelled? == false
          if timer.recurring == true
            newTime = timer.time + timer.interval
            newTimer = Timer.new(newTime, timer.name, timer.interval, timer.recurring, timer.granularity, timer.callback)
            self.insert(newTimer)
          end
          Thread.new do
            timer.callback.call
          end
        end
      end

      untilNext = @events.first.time - time
      if untilNext < 0.0
        untilNext = 0.0
      end
      sleep untilNext
    end


    # Return the current time in milliseconds.
    def get_current_time()
      return  Time.now.gmtime.to_f * GRANULARITY
    end


  end
end