require 'fluent-logger'
# singleton
Fluent::Logger::FluentLogger.open(nil, :format_json => true, :host=>'localhost', :port=>24224)