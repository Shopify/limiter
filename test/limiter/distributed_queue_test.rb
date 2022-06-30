# frozen_string_literal: true

require 'test_helper'

module Limiter
  class DistributedQueueTest < Minitest::Test
    include AssertElapsed

    COUNT = 50
    RATE = 1
    INTERVAL = 1

    def setup
      super
      @queue = DistributedQueue.new(RATE, interval: INTERVAL)
      @queue.stubs(:clock).returns(FakeClock)
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

    def test_block_was_called_on_rate_limit
      @block_hit = false
      @queue = DistributedQueue.new(RATE, interval: INTERVAL) { @block_hit = true }
      @queue.stubs(:clock).returns(FakeClock)
      @queue.shift
      @queue.shift
      assert @block_hit
    end
  end
end
