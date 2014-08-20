require 'fluent-logger'

# add error method for undefined method erorrs
module Fluent
  module Logger

    def self.error(*args)
      # noop
      @@default_logger.post("tegu.error", *args)
    rescue => e
    end

  end # logger
end # fluent

# singleton
Fluent::Logger::FluentLogger.open(nil, format_json: true, host: 'localhost', port: 24224)

