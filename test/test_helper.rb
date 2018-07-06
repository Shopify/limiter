# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'limiter'

require 'minitest/autorun'
require 'timecop'

module Limiter
  module FakeSleep
    def setup
      super
      RateQueue.send(:define_method, :sleep) { |i| Timecop.travel(Time.now + i) }
    end

    def teardown
      RateQueue.send(:remove_method, :sleep)
      super
    end
  end

  module AssertElapsed
    def assert_elapsed(interval)
      started_at = Time.now.to_f

      yield

      completed_at = Time.now.to_f

      assert_in_delta started_at + interval, completed_at, 1.1
    end
  end
end
