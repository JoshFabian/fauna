class ListingReport < ActiveRecord::Base
  include Loggy

  belongs_to :listing, touch: true
  belongs_to :user, touch: true

  validates :listing, presence: true
  validates :user, presence: true, uniqueness: {scope: :listing}

  store :data, accessors: [:message]

  def as_json(options={})
    options ||= {}
    super(except: [:created_at, :data, :updated_at], methods: [:message])
  end
end