# frozen_string_literal: true

module Limiter
  class RateQueue
    EPOCH = 0.0

    def initialize(size, interval: 60, balanced: false)
      @size = size
      @interval = interval

      @ring = balanced ? balanced_ring : unbalanced_ring
      @head = 0
      @mutex = Mutex.new
    end

    def shift
      time = nil

      @mutex.synchronize do
        time = @ring[@head]

        sleep_until(time + @interval)

        @ring[@head] = clock.time
        @head = (@head + 1) % @size
      end

      time
    end

    private

    def sleep_until(time)
      interval = time - clock.time
      return unless interval.positive?
      clock.sleep(interval)
    end

    def clock
      Clock
    end

    def unbalanced_ring
      Array.new(@size, EPOCH)
    end

    def balanced_ring
      (0...@size).map { |i| base_time + (gap * i) }
    end

    def gap
      @interval.to_f / @size.to_f
    end

    def base_time
      clock.time - @interval
    end
  end
end
