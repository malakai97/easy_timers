require 'spec_helper'
require 'easy_timers/timers'

describe EasyTimers::Timers do

  describe '#after(time, name = nil, &block)' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires at a future time' do
      x = 1
      time = Time.now + 0.1
      @timers.after(time, :test) { x = 5}
      expect(x).to eq(1)
      sleep 0.12
      expect(x).to eq(5)
    end

    it 'fires multiple times' do
      x = []
      now = Time.now
      @timers.after(now + 0.6, :a) { x.push(:a) }
      @timers.after(now + 0.5, :b) { x.push(:b) }
      @timers.after(now + 0.4, :c) { x.push(:c) }
      @timers.after(now + 0.3, :d) { x.push(:d) }
      @timers.after(now + 0.2, :e) { x.push(:e) }
      @timers.after(now + 0.1, :f) { x.push(:f) }
      @timers.after(now + 0.25, :g) { x.push(:g) }
      sleep 0.65
      expect(x).to eq([:f, :e, :g, :d, :c, :b, :a])
    end

    it 'generates a custom name' do
      name = nil
      name = @timers.after(Time.now + 0.1) { true }
      expect(name).to_not eq(nil)
    end

  end


  describe '#after(seconds, name = nil, &block)' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires after an interval' do
      x = 1
      @timers.after(0.1, :test) do
        x = 5
      end
      expect(x).to eq(1)
      sleep 0.12
      expect(x).to eq(5)
    end

    it 'fires multiple times in succession' do
      x = []
      @timers.after(0.6, :a) { x.push(:a) }
      @timers.after(0.5, :b) { x.push(:b) }
      @timers.after(0.4, :c) { x.push(:c) }
      @timers.after(0.3, :d) { x.push(:d) }
      @timers.after(0.2, :e) { x.push(:e) }
      @timers.after(0.1, :f) { x.push(:f) }
      @timers.after(0.25, :g) { x.push(:g) }
      sleep 0.65
      expect(x).to eq([:f, :e, :g, :d, :c, :b, :a])

    end

    it 'generates a custom name' do
      name = nil
      name = @timers.after(0.1) { true }
      expect(name).to_not eq(nil)
    end

  end


end