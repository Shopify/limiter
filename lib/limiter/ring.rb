# frozen_string_literal: true

require 'redis'
require 'redlock'

module Limiter
  class Ring
    def initialize(size, key, default)
      @redis = Redis.current
      @redlock = Redlock::Client.new([@redis])
      @size = size
      @key = key
      @default = default

      initialize_ring
    end

    def head
      @redis.get(head_key).to_i
    end

    def current
      (@redis.lindex(ring_key, head) || @default).to_i
    end

    def rotate!
      current_head = head
      current_time = now
      @redis.pipelined do |pipeline|
        pipeline.lset(ring_key, current_head, current_time.to_s)
        pipeline.set(head_key, (current_head + 1) % @size)
      end
    end

    def lock
      completed = false
      timeout_time = monotonic_time + 2000
      while !completed && (monotonic_time < timeout_time)
        @redlock.lock(lock_key, 2000) do |locked|
          if locked
            yield
            completed = true
          end
        end
      end
    end

    def now
      @redis.time[0]
    end

    private

      def head_key
        @head_key ||= key_for(:head)
      end

      def ring_key
        @ring_key ||= key_for(:ring)
      end

      def lock_key
        @lock_key ||= key_for(:lock)
      end

      def key_for(thing)
        ['rate', @key, thing].join(':')
      end

      def initialize_ring
        return unless @redis.llen(ring_key).zero?

        @redis.pipelined do
          1.upto(@size) do
            @redis.lpush(ring_key, @default)
          end
          @redis.set(head_key, 0)
        end
      end

      def monotonic_time
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end
  end
end