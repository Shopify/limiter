# frozen_string_literal: true

module Limiter
  module Mixin
    def limit_method(method, rate:, interval: 60, balanced: false)
      queue = RateQueue.new(rate, interval: interval, balanced: balanced)

      mixin = Module.new do
        if RUBY_VERSION < "2.7"
          define_method(method) do |*args|
            queue.shift
            super(*args)
          end
        else
          define_method(method) do |*args, **kwargs|
            queue.shift
            super(*args, **kwargs)
          end
        end
      end

      prepend mixin
    end
  end
end
