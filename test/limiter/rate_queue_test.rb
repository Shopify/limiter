# frozen_string_literal: true

require "test_helper"

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

    def test_shift_is_not_rate_limited
      assert_elapsed(0) do
        COUNT.times do
          @queue.shift
          @queue.reset
        end
      end
    end

    def test_block_was_called_on_rate_limit
      @block_hit = false
      @queue = RateQueue.new(RATE, interval: INTERVAL) { @block_hit = true }
      @queue.stubs(:clock).returns(FakeClock)
      @queue.shift
      @queue.shift

      assert(@block_hit)
    end

    def test_balanced_ring_reads_the_clock_once
      # a clock that advances one second on every read exposes any per-slot reads
      Clock.stubs(:time).returns(*Array.new(100) { |i| 1000.0 + i })

      subject = RateQueue.new(50, interval: 1, balanced: true)
      ring = subject.instance_variable_get(:@ring)

      ring.each_cons(2) do |previous, current|
        assert_in_delta(0.02, current - previous, 1e-9)
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
