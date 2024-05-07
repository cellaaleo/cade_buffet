class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :venue
  belongs_to :event
  has_one :quotation
  
  enum status: { pending: 0, approved: 3, confirmed: 6, canceled: 9 }

  validates :code, :event_date, :number_of_guests, presence: true
  validate  :event_date_must_be_one_month_from_now, 
            :number_of_guests_must_be_greater_than_or_equal_to_minimum_guests_number, 
            :number_of_guests_must_be_less_than_or_equal_to_maximum_guests_number

  before_validation :generate_code, on: :create

  def base_price
    if event_date.saturday? || event_date.sunday?
      event.price.weekend_base_price
    else
      event.price.weekday_base_price
    end
  end

  def extra_guests_number
    if number_of_guests > event.minimum_guests_number
      number_of_guests - event.minimum_guests_number
    else
      0
    end
  end

  def plus_per_person
    return event.price.weekend_plus_per_person if event_date.saturday? || event_date.sunday?
    event.price.weekday_plus_per_person
  end
=begin
  def set_extra_guest_tax
    if event_date.saturday? || event_date.sunday?
      event.price.weekend_plus_per_person * extra_guests_number
    else
      event.price.weekday_plus_per_person * extra_guests_number
    end
  end
=end
  def subtotal
    base_price + (extra_guests_number * plus_per_person)
  end

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
    if self.number_of_guests.present? && self.number_of_guests > self.event.maximum_guests_number
      self.errors.add(:number_of_guests, "deve ser no máximo #{self.event.maximum_guests_number}")
    end
  end
end
