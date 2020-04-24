# frozen_string_literal: true

require 'test_helper'

module Limiter
  class ClockTest < Minitest::Test
    def setup
      super
      @start_time = Clock.time
    end

    def test_clock_is_advancing
      assert Clock.time > @start_time
    end

    def test_skips_interval
      Clock.skip(300)
      assert Clock.time >= (@start_time + 300)
    end
  end
end
