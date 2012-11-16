require 'lib/reporter_config'
require 'vizify-statsd'
require 'logger'

module Statsd
  Vizify::Statsd::Proxy.configure(ReporterConfig.statsd_host, ReporterConfig.statsd_port, ReporterConfig.statsd_app_name, ReporterConfig.statsd_enabled, ReporterConfig.statsd_log_type)

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
