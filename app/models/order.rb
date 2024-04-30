class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :venue
  belongs_to :event
end
