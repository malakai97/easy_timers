require 'spec_helper'

describe EasyTimers::Timers do

  describe '#after(time, name = nil, &block)' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires at a future time' do
      pending
    end

    it 'fires multiple times' do
      pending
    end

    it 'generates a custom name' do
      pending
    end

  end


  describe '#after(seconds, name = nil, &block)' do
    before(:each) do
      @timers = EasyTimers::Timers.new()
    end

    it 'fires after an interval' do
      x = 1
      @timers.after(0.1, :test) { x == 5 }
      x.should == 1
      sleep 0.11
      x.should == 5
    end

    it 'fires multiple times in succession' do
      pending
    end

    it 'generates a custom name' do
      pending
    end

  end


end