# frozen_string_literal: true

module Limiter
  module Mixin
    def limit_method(method, rate:, interval: 60)
      queue = RateQueue.new(rate, interval: interval)

      mixin = Module.new do
        if RUBY_VERSION < "2.7"
          define_method(method) do |*args|
            queue.shift
            super(*args)
          end
        else
          define_method(method) do |*positional_args, **keyword_args|
            queue.shift
            super(*positional_args, **keyword_args)
          end
        end
      end

      prepend mixin
    end
  end
end
