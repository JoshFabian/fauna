class ListingConversation < ActiveRecord::Base
  include Loggy

  validates :conversation, presence: true
  validates :listing, presence: true

  belongs_to :conversation
  belongs_to :listing

end