# frozen_string_literal: true

require 'test_helper'

module Limiter
  class RateQueueTest < Minitest::Test
    COUNT = 50
    RATE = 1
    INTERVAL = 1

    def setup
      super
      @queue = RateQueue.new(RATE, interval: INTERVAL)
      RateQueue.send(:define_method, :sleep) { |i| Timecop.travel(Time.now + i) }
    end

    def teardown
      RateQueue.send(:remove_method, :sleep)
      super
    end

    def test_shift_is_rate_limited
      start = Time.now

      COUNT.times do
        @queue.shift
      end

      assert_equal (start.to_i + (COUNT / RATE) - 1).to_i, Time.now.to_i
    end

    def test_shift_is_rate_limited_across_multiple_threads
      threads = Array.new(COUNT) do
        Thread.new do
          @queue.shift
          Time.now
        end
      end

      times = threads.map(&:value)

      assert_equal (times.min + (COUNT / RATE) - 1).to_i, times.max.to_i
    end
  end
end
