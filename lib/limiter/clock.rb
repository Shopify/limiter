# frozen_string_literal: true

require 'singleton'

module Limiter
  class Clock
    include Singleton

    extend SingleForwardable
    def_single_delegators :instance, :skip, :time

    def initialize
      @offset = 0
    end

    def skip(interval)
      @offset += interval
    end

    def time
      now + @offset
    end

    private

    def now
      Time.now
    end
  end
end
