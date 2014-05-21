module Loggy
  # class methods
  module ClassMethods
    def logger
      Fluent::Logger
    end

    def log_data
      {timestamp: Time.now.utc.to_s(:standard), env: Rails.env}
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # instance methods

  def logger
    Fluent::Logger
  end

  def log_data
    {:timestamp => Time.now.utc.to_s(:standard), env: Rails.env}
  end
end