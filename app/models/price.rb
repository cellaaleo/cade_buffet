class Price < ApplicationRecord
  belongs_to :event

  validates :weekday_base_price, :weekday_plus_per_person, :weekday_plus_per_hour, 
            :weekend_base_price, :weekend_plus_per_person, :weekend_plus_per_hour, 
            presence: true
  
end
