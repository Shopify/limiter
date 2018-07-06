# frozen_string_literal: true

require 'test_helper'

module Limiter
  class RateQueueTest < Minitest::Test
    include FakeSleep
    include AssertElapsed

    COUNT = 50
    RATE = 1
    INTERVAL = 1

    def setup
      super
      @queue = RateQueue.new(RATE, interval: INTERVAL)
    end

    def test_shift_is_rate_limited
      assert_elapsed(COUNT.to_f / RATE - 1) do
        COUNT.times do
          @queue.shift
        end
      end
    end

    def test_shift_is_rate_limited_across_multiple_threads
      assert_elapsed(COUNT.to_f / RATE - 1) do
        threads = Array.new(COUNT) do
          Thread.new do
            @queue.shift
          end
        end

        threads.each(&:join)
      end
    end
  end
end
