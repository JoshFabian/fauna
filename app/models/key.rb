class Key < ActiveRecord::Base
  include Loggy

  validates :env, presence: true
  validates :name, presence: true, uniqueness: {scope: :env}
  validates :value, presence: true, uniqueness: {scope: [:name, :env]}

  def self.get(options={})
    find_by(env: options[:env] || Rails.env, name: options[:name])
  end

  def self.get_names(options={})
    Key.where(env: options[:env] || Rails.env).pluck(:name)
  end

  def self.get_value(options={})
    get(options).try(:value)
  end
end