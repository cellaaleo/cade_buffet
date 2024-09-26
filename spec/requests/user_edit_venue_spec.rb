require 'rails_helper'

RSpec.describe 'Usuário edita buffet' do
  it 'e não está autenticado' do
    venue = create :venue

    patch venue_path(venue.id), params: { venue: { phone_number: '(31)99220-9292' } }

    expect(response).to redirect_to new_user_session_path
  end

  it 'que não está vinculado à sua conta' do
    first_venue = create :venue
    second_venue = create :venue

    login_as second_venue.user, scope: :user
    patch venue_path(first_venue.id), params: { venue: { phone_number: '(31)99220-9292' } }

    expect(response).to redirect_to venue_path(second_venue.id)
  end
end
