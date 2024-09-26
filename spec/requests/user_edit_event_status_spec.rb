require 'rails_helper'

describe 'Dono de Buffet altera status de um evento' do
  context 'para inativo' do
    it 'e não está autenticado' do
      event = create :event, status: :active

      post inactive_event_path(event.id)

      expect(response).to redirect_to new_user_session_path
    end

    it 'e não é o responsável' do
      first_venue = create :venue
      second_venue = create :venue
      event = create :event, venue: first_venue, status: :active

      login_as second_venue.user, scope: :user
      post inactive_event_path(event.id)

      expect(response).to redirect_to venue_path(second_venue.id)
    end
  end

  context 'para ativo' do
    it 'e não está autenticado' do
      event = create :event, status: :inactive

      post active_event_path(event.id)

      expect(response).to redirect_to new_user_session_path
    end

    it 'e não é o responsável' do
      first_venue = create :venue
      second_venue = create :venue
      event = create :event, venue: first_venue, status: :inactive

      login_as second_venue.user, scope: :user
      post active_event_path(event.id)

      expect(response).to redirect_to venue_path(second_venue.id)
    end
  end
end
