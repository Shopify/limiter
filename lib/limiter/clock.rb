# frozen_string_literal: true

require 'singleton'
require 'forwardable'

module Limiter
  class Clock
    include Singleton

    extend SingleForwardable
    def_single_delegators :instance, :sleep, :time

    def sleep(interval)
      Kernel.sleep(interval)
    end

    def time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
