require 'lib/stat'

class StatCollection
  attr_accessor :stats

  def initialize
    @stats = Hash.new()
  end

  def append(key, value, is_aggregate = false)
    value_populated = @stats.has_key?(key) && !@stats[key].nil?
    if value_populated
      @stats[key].append(value.to_f)
    else
      @stats[key] = Stat.new(value.to_f, is_aggregate)
    end
  end

  def keys
    @stats.keys
  end

  def is_aggregated?(key)
    @stats[key].is_aggregated
  end

  def average(key, round_digits = 3)
    @stats[key].average(round_digits)
  end

  def sum(key, round_digits = 3)
    @stats[key].sum(round_digits)
  end
end
