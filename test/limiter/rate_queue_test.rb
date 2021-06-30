# frozen_string_literal: true

require 'test_helper'

module Limiter
  class RateQueueTest < Minitest::Test
    include AssertElapsed

    COUNT = 50
    RATE = 1
    INTERVAL = 1

    def setup
      super
      @queue = RateQueue.new(RATE, interval: INTERVAL)
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

    def test_shift_is_unbalanced_by_default
      actual = @queue.instance_variable_get(:@ring)
      actual.size.times.with_index do |idx|
        assert_in_delta(actual[idx], 0.0)
      end
    end

    def test_shift_is_balanced
      subject = RateQueue.new(5, interval: 5, balanced: true)
      expected = [
        Clock.time - 5,
        Clock.time - 4,
        Clock.time - 3,
        Clock.time - 2,
        Clock.time - 1,
      ]
      actual = subject.instance_variable_get(:@ring)
      actual.size.times.with_index do |idx|
        assert_in_delta(actual[idx], expected[idx])
      end
    end
  end
end
