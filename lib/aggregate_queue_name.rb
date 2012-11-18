require 'lib/reporter_config'

class AggregateQueueName

  attr_reader :is_aggregated

  def initialize(queue_name, metric_name)
    @queue_name = queue_name
    @metric_name = metric_name
    @aggregated_metrics = ReporterConfig.kestrel_aggregated_metrics
    @is_aggregated = false
  end

  def name
    get_queue_key(@queue_name, @metric_name)
  end

  private

  def get_queue_key(queue_name, metric_name)
    sq_name = standardize_queue_name(queue_name.to_s)
    ['queue', sq_name, metric_name].join('.')
  end

  def standardize_queue_name(queue_name)
    @aggregated_metrics.each do |metric_name|
      if queue_name.start_with?("#{metric_name}-")
        @is_aggregated = true
        return "#{metric_name}_aggregated"
      end
    end
    queue_name
  end
end
