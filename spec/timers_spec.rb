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

    it 'fires immediately when given a time in the past' do
      x = 0
      time = Time.now - 0.1
      @timers.after(time, :test) { x = 5 }
      sleep 0.05
      expect(x).to eq(5)
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

    it 'fires immediately when given a time in the past' do
      x = 0
      @timers.after(-0.1, :test) { x = 5 }
      sleep 0.1
      expect(x).to eq(5)
    end

  end


  describe '#every' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires more than once' do
      x = 0
      @timers.every(0.1) { x += 1}
      sleep 0.05
      expect(x).to eq(0)
      sleep 0.1
      expect(x).to eq(1)
      sleep 0.1
      expect(x).to eq(2)
      sleep 0.1
      expect(x).to eq(3)
    end

    it 'works with a staggered timer' do
      x = []
      @timers.every(0.3) { x.push(:a) }
      sleep 0.1
      @timers.every(0.3) { x.push(:b) }
      sleep 0.7
      expect(x).to eq([:a, :b, :a, :b])
    end

    it 'works with a similar timer' do
      x = 0
      @timers.every(0.1) { x += 1 }
      @timers.every(0.1) { x += 1 }
      sleep 0.45
      expect(x).to eq(8)
    end

    it 'generates a custom name' do
      name = nil
      name = @timers.every(0.1) { true }
      expect(name).to_not eq(nil)
    end

  end

  describe '#after_then_every(start_seconds, interval, name = nil, &block)' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires after seconds then fires again' do
      x = 0
      @timers.after_then_every(0.2, 0.1) { x += 1}
      expect(x).to eq(0)
      sleep 0.25
      expect(x).to eq(1)
      sleep 0.2
      expect(x).to eq(3)
    end

    it 'works with a staggered timer' do
      x = []
      @timers.after_then_every(0.2, 0.1) { x.push(:a) }
      @timers.after_then_every(0.25, 0.1) { x.push(:b) }
      sleep 0.58
      expect(x).to eq([:a, :b, :a, :b, :a, :b, :a, :b])
    end

    it 'works with a similar timer' do
      x = 0
      @timers.after_then_every(0.2, 0.4) { x += 1 }
      @timers.after_then_every(0.2, 0.4) { x += 1 }
      sleep 0.8
      expect(x).to eq(4)
    end

    it 'generates a custom name' do
      name = nil
      name = @timers.after_then_every(0.1, 0.1) { true }
      expect(name).to_not eq(nil)
    end
  end

  describe '#cancel' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'deletes an #after timer' do
      x = 0
      @timers.after(0.1, :test) { x += 1 }
      @timers.cancel(:test)
      sleep 0.15
      expect(x).to eq(0)
    end

    it 'deletes an #every timer after it has fired' do
      x = 0
      @timers.every(0.1, :test) { x += 1 }
      sleep 0.25
      @timers.cancel(:test)
      sleep 0.1
      expect(x).to eq(2)
    end

    it 'fails gracefully if the timer is past' do
      x = 0
      @timers.after(0.1, :test) { x += 1 }
      sleep 0.15
      @timers.cancel(:test)
    end

    it 'fails gracefully if the timer never existed' do
      @timers.cancel(:fake)
    end

    it 'works with generated names' do
      x = 0
      name = @timers.after(0.1) { x += 1 }
      @timers.cancel(name)
      sleep 0.15
      expect(x).to eq(0)
    end
  end


end