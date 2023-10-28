# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'limiter'

require 'minitest/autorun'
require 'minitest/focus'
require 'mocha/minitest'

module Limiter
  class FakeClock < Clock
    def initialize
      super
      @offset = 0
    end

    def sleep(interval)
      @offset += interval
    end

    def time
      super + @offset
    end
  end

  module AssertElapsed
    def assert_elapsed(interval)
      started_at = FakeClock.time

      yield

      completed_at = FakeClock.time

      assert_in_delta(started_at + interval, completed_at, 1.1)
    end
  end
end
