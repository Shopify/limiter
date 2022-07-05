# CHANGELOG
​
## v3.0.1
​
- Stop calling Redis on initialization

## v3.0.0

- Add support to redis-based queues for distributed systems

## v2.2.2

- security update to rake 13.0.6 [CVE-2020-8130]

## v2.2.0

- adds support for "balancing" requests over time

## v2.1.0

- add support to call a block when limiting takes place

## v2.0.1

- eliminate kwarg warning in ruby 2.7 (while still supporting 2.6)

## v2.0.0

- end support for ruby 2.3/2.4/2.5
- test on ruby 2.6/2.7/3.0 (using ruby 2.7 for development)

## v1.1.0

- using Process.clock_gettime(Process::CLOCK_MONOTONIC) instead of Time.now for improved accuracy

## v1.0.2

- DOCFIX: fix name of gem in README
- BUGFIX: add ruby-limiter.rb so that it works better with bundler

## v1.0.1

- BUGFIX: support arguments for throttled methods

## v1.0.0

- initial release
