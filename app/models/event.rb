class Event < ApplicationRecord
  belongs_to :venue
  has_one :price
  
  validates :name, :minimum_guests_number, :maximum_guests_number, :duration, presence: true
end
