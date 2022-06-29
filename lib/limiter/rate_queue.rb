# frozen_string_literal: true

module Limiter
  class RateQueue < BaseQueue
    def initialize(size, interval: 60, balanced: false, &blk)
      @size = size
      @interval = interval

      @ring = balanced ? balanced_ring : unbalanced_ring
      @head = 0
      @mutex = Mutex.new
      @blk = blk
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
