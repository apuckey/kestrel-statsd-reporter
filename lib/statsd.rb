require 'lib/stats_reporter_config'
require 'vizify-statsd'
require 'logger'

module Statsd
  Vizify::Statsd::Proxy.configure(StatsReporterConfig.statsd_host, StatsReporterConfig.statsd_port, StatsReporterConfig.statsd_app_name, StatsReporterConfig.statsd_enabled)

  class Send
    class << self
      def timing(key, time)
        Vizify::Statsd::Proxy.timing(key, time)
      end

      def increment(key)
        Vizify::Statsd::Proxy.increment(key)
      end

      def send_stats(stats)
        Vizify::Statsd::Proxy.send_stats(stats)
      end
    end
  end

  class Keys
    class << self

    end
  end
end
