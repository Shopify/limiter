# frozen_string_literal: true

module Limiter
  module Mixin
    def limit_method(method, rate:, interval: 60, balanced: false, &b)
      queue = RateQueue.new(rate, interval: interval, balanced: balanced, &b)

      mixin = Module.new do
        define_method(method) do |*args, **options, &blk|
          queue.shift
          options.empty? ? super(*args, &blk) : super(*args, **options, &blk)
        end
      end

      prepend mixin
    end
  end
end
