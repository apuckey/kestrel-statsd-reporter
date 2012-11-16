$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require 'lib/kestrel_stats_reporter'

KestrelStatsReporter.new.report()
