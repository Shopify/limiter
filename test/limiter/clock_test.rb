# frozen_string_literal: true

require 'test_helper'

module Limiter
  class ClockTest < Minitest::Test
    def setup
      super
      @start_time = Clock.time
    end

    def test_clock_is_advancing
      assert_operator Clock.time, :>, @start_time
    end
  end
end
