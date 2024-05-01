class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :venue
  belongs_to :event
  
  enum status: { pending: 0, confirmed: 5, canceled: 9 }

  validates :code, :event_date, :number_of_guests, presence: true
  validate  :event_date_must_be_one_month_from_now, 
            :number_of_guests_must_be_greater_than_or_equal_to_minimum_guests_number, 
            :number_of_guests_must_be_less_than_or_equal_to_maximum_guests_number

  before_validation :generate_code

  private

  def generate_code
    self.code =  SecureRandom.alphanumeric(8).upcase
  end

  def event_date_must_be_one_month_from_now
    if self.event_date.present? && self.event_date <= 1.month.from_now - 1.day
      self.errors.add(:event_date, "deve ser a partir de #{I18n.localize(1.month.from_now.to_date)}") 
    end
  end

  def number_of_guests_must_be_greater_than_or_equal_to_minimum_guests_number
    if self.number_of_guests.present? && self.number_of_guests < self.event.minimum_guests_number
      self.errors.add(:number_of_guests, "deve ser no mínimo #{self.event.minimum_guests_number}")
    end
  end

  def number_of_guests_must_be_less_than_or_equal_to_maximum_guests_number
    if self.number_of_guests.present? && self.number_of_guests > self.event.maximun_guests_number
      self.errors.add(:number_of_guests, "deve ser no máximo #{self.event.maximun_guests_number}")
    end
  end
end
