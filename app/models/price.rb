class Price < ApplicationRecord
  belongs_to :event

  validates :event_id, presence: true
  
end
