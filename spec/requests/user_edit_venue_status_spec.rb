require 'rails_helper'

describe 'Usuário altera status do buffet' do
  context 'para inativo' do
    it 'e não está autenticado' do
      venue = create :venue, status: :active

      post inactive_venue_path(venue.id)

      expect(response).to redirect_to new_user_session_path
    end

    it 'e não é o responsável' do
      first_venue = create :venue, status: :active
      second_venue = create :venue, status: :active

      login_as second_venue.user, scope: :user
      post inactive_venue_path(first_venue.id)

      expect(response).to redirect_to venue_path(second_venue.id)
    end
  end

  context 'para ativo' do
    it 'e não está autenticado' do
      venue = create :venue, status: :inactive

      post active_venue_path(venue.id)

      expect(response).to redirect_to new_user_session_path
    end

    it 'e não é o responsável' do
      first_venue = create :venue, status: :inactive
      second_venue = create :venue, status: :inactive

      login_as second_venue.user, scope: :user
      post active_venue_path(first_venue.id)

      expect(response).to redirect_to venue_path(second_venue.id)
    end
  end
end
