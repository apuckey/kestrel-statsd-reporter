require 'lib/stat_collection'
require 'lib/stats_payload'
require 'json'
require 'pp'

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
      puts "Unable to parse stats from Kestrel: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  def filter_and_normalize(stats)
    filter_counters(stats['counters'])
    filter_gauges(stats['gauges'])
    #filter_metrics(stats['metrics'])
    prepare_payload()
  end

  def prepare_payload()
    @payload.convert_to_counters(@queue_stats)
    @payload
  end

  def filter_counters(stats)
    fill_queue_stats(stats)
  end

  def filter_gauges(stats)
    fill_queue_stats(stats)
  end

  def fill_queue_stats(stats)
    stats.each_pair do |key, value|
      key_parts = key.split('/')
      if key_parts.length > 1 && key_parts[0] == 'q' # it's a queue
        queue_name = key_parts[1]
        stat_name = key_parts[2]
        @queue_stats.append(get_queue_key(queue_name, stat_name), value)
      else # regular stat
        @queue_stats.append(key, value)
      end
    end
  end

  def get_queue_key(queue_name, stat_name)
    sq_name = standardize_queue_name(queue_name.to_s)
    ['queue', sq_name, stat_name].join('.')
  end

  def filter_metrics(stats)
    # nothing for now, not really even sure what these mean
  end

  def standardize_queue_name(queue_name)
    # TODO: toss these names in the config?
    reserved_names = %w(post_nlp personagoid)
    reserved_names.each do |reserved_name|
      if queue_name.start_with?("#{reserved_name}-")
        return reserved_name
      end
    end
    queue_name
  end
end
