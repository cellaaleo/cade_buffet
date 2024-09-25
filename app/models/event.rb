class Event < ApplicationRecord
  belongs_to :venue
  has_one :price, dependent: :destroy
  enum status: { active: 0, inactive: 1 }

  validates :name, :minimum_guests_number, :maximum_guests_number, :duration, presence: true
end
