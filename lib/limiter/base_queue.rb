# frozen_string_literal: true

module Limiter
  class BaseQueue
    EPOCH = 0.0

    def shift
      raise ArgumentError, "This method should be implemented in a child class"
    end

    private

    def sleep_until(time, clock_time = Proc.new { clock.time })
      interval = time - clock_time.call
      return unless interval.positive?
      @blk.call if @blk
      clock.sleep(interval)
    end

    def clock
      Clock
    end
  end
end
