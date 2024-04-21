class Event < ApplicationRecord
  belongs_to :venue
  has_one :price
  
  validates :name, presence: true
end
