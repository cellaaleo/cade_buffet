require 'rails_helper'

RSpec.describe 'Dono de buffet vê um buffet' do
  it 'que não está vinculado à sua conta' do
    first_venue = create :venue
    second_venue = create :venue

    login_as first_venue.user, scope: :user
    get(venue_path(second_venue.id))

    expect(response).to redirect_to(venue_path(first_venue.id))
  end
end
