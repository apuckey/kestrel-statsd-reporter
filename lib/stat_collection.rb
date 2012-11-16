class StatCollection
  attr_accessor :data

  def initialize
    @data = Hash.new()
  end

  def append(key, value)
    if @data.has_key?(key)
      @data[key] << value.to_f
    else
      @data[key] = [value.to_f]
    end
  end

  def keys
    @data.keys
  end

  def get(key)
    @data[key]
  end

  def average(key)
    sum(key) / @data[key].length
  end

  def sum(key)
    @data[key].inject(0.0) {|sum, item| sum + item }
  end
end
