class StatsPayload
  attr_accessor :counters, :timings

  def initialize(counters = {}, timings = {})
    # expects a hash like: @counters['stat.name'] = "42|c"
    @counters = counters

    # expects a hash like: @counters['stat.name'] = '123' # in ms
    @timings = timings
  end

  def convert_to_counters(stat_collection)
    stat_collection.keys.each do |key|
      @counters["#{key}.mean"] = stat_collection.average(key).to_s + "|c"
      @counters["#{key}.sum"] = stat_collection.sum(key).to_s + "|c"
    end
  end
end
