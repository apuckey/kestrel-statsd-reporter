class Stat
  attr_accessor :data, :is_aggregated

  def initialize(stat, is_aggregated = false)
    @stat = [stat]
    @is_aggregated = is_aggregated
  end

  def append(value)
    @stat << value
  end

  def average(round_digits = 3)
    (sum() / @stat.length).round(round_digits)
  end

  def sum(round_digits = 3)
    (@stat.inject(0.0) {|sum, item| sum + item }).round(round_digits)
  end
end
