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
      index = @events.index do |element|
        timer.time > element.time
      end

      if index == nil
        @events.push(timer)
      else
        @events.insert(index, timer)
      end

      @names[timer.name].push(timer)
      @looping_thread.run()
      return timer.name
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
      if @events.empty?
        sleep #until woken
      else
        time = self.get_current_time()

        while @events.last.time <= time
          timer = @events.pop
          @names[timer.name].pop
          if timer.cancelled? == false
            if timer.recurring == true
              newTime = timer.time + timer.interval
              newTimer = Timer.new(newTime, timer.name, timer.interval, timer.recurring, timer.callback)
              self.insert(newTimer)
            end
            Thread.new do
              timer.callback.call
            end
          end
        end

        untilNext = @events.last.time - time
        if untilNext < 0.0
          untilNext = 0.0
        end
        sleep untilNext
      end
    end


    # Return the current time in seconds
    def get_current_time()
      return  Time.now.gmtime.to_f
    end


  end
end