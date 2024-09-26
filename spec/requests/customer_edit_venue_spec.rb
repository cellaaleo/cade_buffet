require 'rails_helper'

RSpec.describe 'Cliente edita buffet' do
  it 'e não tem autorização' do
    venue = create :venue
    customer = create :customer

    login_as customer, scope: :customer
    patch venue_path(venue.id), params: { venue: { phone_number: '(31)99220-9292' } }

    expect(response).to redirect_to new_user_session_path
  end
end
