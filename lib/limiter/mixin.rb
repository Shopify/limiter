module Limiter
  module Mixin
    def limit_method(method, rate:, interval: 60)
      queue = RateQueue.new(rate, interval: interval)

      mixin = Module.new do
        define_method(method) do
          queue.shift
          super()
        end
      end

      prepend mixin
    end
  end
end
