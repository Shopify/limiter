# frozen_string_literal: true

module Limiter
  class DistributedQueue < BaseQueue
    def initialize(size, interval: 60, key: 'queue', &blk)
      @ring = Ring.new(size, key, EPOCH)
      @interval = interval
    end

    def shift
      time = nil

      @ring.lock do
        sleep_until(@ring.current + @interval, Proc.new { @ring.now } )
        @ring.rotate!
      end

      time
    end
  end
end
