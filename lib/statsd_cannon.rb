require 'lib/stats_payload'
require 'lib/statsd'

class StatsdCannon

  class << self
    def fire(stats_payload)
      fire_counters(stats_payload.counters)
      fire_timings(stats_payload.timings)
    end

    def fire_counters(counters)
      # expects a hash of form key="stat.name", value="1|c" or value="42|c"
      # counters['stat.name'] = "42|c"
      Statsd::Send.send_stats(counters)
    end

    def fire_timings(timings)
      timings.each_pair do |key, value|
        Statsd::Send.timing(key, value)
      end
    end
  end
end
