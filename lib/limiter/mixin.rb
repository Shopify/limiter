# frozen_string_literal: true

module Limiter
  module Mixin
    def limit_method(method, rate:, interval: 60, balanced: false, distributed: false, &b)
      queue = if !distributed
                RateQueue.new(rate, interval: interval, balanced: balanced, &b)
              else
                DistributedQueue.new(rate, interval: interval, key: "#{self.name}##{method}", &b)
              end

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
