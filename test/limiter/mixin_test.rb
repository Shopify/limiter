# frozen_string_literal: true

require 'test_helper'

module Limiter
  class MixinTest < Minitest::Test
    include AssertElapsed

    COUNT = 50
    RATE = 1
    INTERVAL = 1

    class MixinTestClass
      extend Limiter::Mixin

      limit_method :tick, rate: RATE, interval: INTERVAL
      limit_method :tick_with_kwargs, rate: RATE, interval: INTERVAL

      attr_reader :ticks

      def initialize
        @ticks = 0
      end

      def tick(count = 1)
        @ticks += count
      end

      def tick_with_kwargs(count: 1)
        @ticks += count
      end
    end

    def setup
      super
      RateQueue.any_instance.stubs(:clock).returns(FakeClock)
      @object = MixinTestClass.new
    end

    def test_method_is_rate_limited
      assert_elapsed(COUNT.to_f / RATE - 1) do
        COUNT.times do
          @object.tick
        end
      end
    end

    def test_original_method_is_called
      COUNT.times do
        @object.tick
      end

      assert_equal COUNT, @object.ticks
    end

    def test_positional_arguments
      @object.tick 123
      assert_equal 123, @object.ticks
    end

    def test_keyword_arguments
      @object.tick_with_kwargs(count: 123)
      assert_equal 123, @object.ticks
    end
  end
end
