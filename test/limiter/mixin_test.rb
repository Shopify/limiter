# frozen_string_literal: true

require 'test_helper'

module Limiter
  class MixinTest < Minitest::Test
    COUNT = 50
    RATE = 1
    INTERVAL = 1

    class MixinTestClass
      extend Limiter::Mixin

      limit_method :tick, rate: RATE, interval: INTERVAL

      attr_reader :ticks

      def initialize
        @ticks = 0
      end

      def tick
        @ticks += 1
      end
    end

    def setup
      super
      RateQueue.send(:define_method, :sleep) { |i| Timecop.travel(Time.now + i) }
    end

    def teardown
      RateQueue.send(:remove_method, :sleep)
      super
    end

    def test_method_is_rate_limited
      object = MixinTestClass.new

      start = Time.now

      COUNT.times do
        object.tick
      end

      assert_equal (start.to_i + (COUNT / RATE) - 1).to_i, Time.now.to_i
    end

    def test_original_method_is_called
      object = MixinTestClass.new

      COUNT.times do
        object.tick
      end

      assert_equal COUNT, object.ticks
    end
  end
end
