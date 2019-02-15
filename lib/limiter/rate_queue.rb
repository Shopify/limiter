# frozen_string_literal: true

module Limiter
  class RateQueue
    EPOCH = Time.at(0)

    def initialize(size, interval: 60)
      @size = size
      @interval = interval

      @ring = Array.new(size, EPOCH)
      @head = 0
      @mutex = Mutex.new
    end

    def shift
      time = nil

      @mutex.synchronize do
        time = @ring[@head]

        sleep_until(time + @interval)

        @ring[@head] = Clock.time
        @head = (@head + 1) % @size
      end

      time
    end

    private

    def sleep_until(time)
      interval = time - Clock.time
      return unless interval.positive?
      sleep(interval)
    end
  end
end
