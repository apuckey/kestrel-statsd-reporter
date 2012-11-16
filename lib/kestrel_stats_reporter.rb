require 'lib/stats_reporter_config'
require 'lib/kestrel_stats_parser'
require 'lib/statsd_cannon'
require 'net/http'
require 'json'
require 'pp'

class KestrelStatsReporter
  def initialize
    host = StatsReporterConfig.kestrel_host
    port = StatsReporterConfig.kestrel_port
    path = StatsReporterConfig.kestrel_path
    namespace = StatsReporterConfig.kestrel_namespace

    @uri_string = "http://#{host}:#{port}/#{path}?namespace=#{namespace}"
  end

  def fetch_stats
    begin
      return Net::HTTP.get(URI(@uri_string))
    rescue Exception => e
      puts "Unable to fetch stats from Kestrel: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  def report
    raw_stats = fetch_stats()
    parser = KestrelStatsParser.new(raw_stats)
    normalized_stats = parser.parse_and_normalize
    #pp normalized_stats
    StatsdCannon.fire(normalized_stats)
  end
end
