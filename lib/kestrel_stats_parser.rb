require 'lib/aggregate_queue_name'
require 'lib/stat_collection'
require 'lib/stats_payload'
require 'json'

class KestrelStatsParser
  attr_accessor :raw_stats

  def initialize(raw_stats)
    @raw_stats = raw_stats
    @payload = StatsPayload.new
    @queue_stats = StatCollection.new
  end

  def parse_and_normalize
    stats = parse()
    filter_and_normalize(stats)
  end

  private

  def parse
    begin
      return JSON.parse(@raw_stats)
    rescue Exception => e
      abort("Unable to parse stats from Kestrel: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end

  def filter_and_normalize(stats)
    fill_queue_stats(stats['counters'])
    fill_queue_stats(stats['gauges'])
    # not really sure what 'metrics' mean, so leaving these out
    #filter_metrics(stats['metrics'])
    prepare_payload()
  end

  def prepare_payload()
    @payload.convert_to_counters(@queue_stats)
    @payload
  end

  def fill_queue_stats(stats)
    stats.each_pair do |key, value|
      key_parts = key.split('/')
      if key_parts.length > 1 && key_parts[0] == 'q' # it's a queue
        aqn = AggregateQueueName.new(key_parts[1], key_parts[2])
        @queue_stats.append(aqn.name, value, aqn.is_aggregated)
      else # regular stat
        @queue_stats.append(key, value)
      end
    end
  end

end
