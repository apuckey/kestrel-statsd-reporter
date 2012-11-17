require 'yaml'
require 'erb'

class ReporterConfig
  @@config = nil
  DEFAULT_CONFIG = File.join(File.dirname(__FILE__), '..', 'config', 'config.yml')

  class << self
    def get_rack_env_or_default
      env = ENV['RACK_ENV']
      env ||= 'development'
      return env
    end

    def get_config
      if @@config.nil?
        @@config = set_config(DEFAULT_CONFIG)
      end
      env = get_rack_env_or_default()
      return @@config[env]
    end

    def set_config(filename)
      @@config = YAML.load(ERB.new(File.new(filename).read).result)
    end

    def get_kestrel_config
      get_config['kestrel']
    end

    def kestrel_host
      get_kestrel_config['host']
    end

    def kestrel_port
      get_kestrel_config['port']
    end

    def kestrel_path
      get_kestrel_config['path']
    end

    def kestrel_namespace
      get_kestrel_config['namespace']
    end

    def kestrel_aggregated_metrics
      get_kestrel_config['aggregated_metrics'] || []
    end

    def get_statsd_config
      get_config['statsd']
    end

    def statsd_enabled
      get_statsd_config['enabled']
    end

    def statsd_app_name
      get_statsd_config['app_name']
    end

    def statsd_host
      get_statsd_config['host']
    end

    def statsd_port
      get_statsd_config['port']
    end

    def statsd_log_type
      log_path = get_statsd_config['log_path']
      return Rails.logger if log_path == 'rails'
      return Logger.new(log_path) unless log_path.nil?
      return nil
    end
  end
end
