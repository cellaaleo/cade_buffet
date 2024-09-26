require 'rails_helper'

describe 'Dono de Buffet edita status de um evento' do
  it 'e evento é desativado' do
    venue = create :venue
    create :event, name: 'Aniversário', venue: venue, status: :active

    login_as venue.user, scope: :user
    visit venue_path(venue.id)
    click_on 'Aniversário'
    click_on 'Desativar Evento'

    expect(page).to have_content 'Evento desativado com sucesso'
    expect(page).to have_button 'Reativar Evento'
    expect(page).not_to have_button 'Desativar Evento'
  end

  it 'e evento não aparece na relação de eventos que realiza' do
    venue = create :venue
    create :event, name: 'Aniversário', venue: venue, status: :inactive
    create :event, name: 'Halloween', venue: venue, status: :active

    login_as venue.user, scope: :user
    visit venue_path(venue.id)

    expect(page).not_to have_content 'Aniversário'
    expect(page).to have_content 'Halloween'
  end

  it 'e vê relação de eventos desativados' do
    venue = create :venue
    create :event, name: 'Aniversário', venue: venue, status: :inactive
    create :event, name: 'Halloween', venue: venue, status: :active

    login_as venue.user, scope: :user
    visit venue_path(venue.id)
    click_on 'Ver eventos desativados'

    # Assert
    expect(current_path).to eq deactivated_venue_events_path(venue.id)
    expect(page).to have_content 'Eventos desativados'
    expect(page).to have_content 'Aniversário'
    expect(page).not_to have_link 'Halloween'
  end

  it 'e evento é reativado' do
    venue = create :venue
    create :event, name: 'Aniversário', venue: venue, status: :inactive
    create :event, name: 'Halloween', venue: venue, status: :active

    login_as venue.user, scope: :user
    visit venue_path(venue.id)
    click_on 'Ver eventos desativados'
    click_on 'Aniversário'
    click_on 'Reativar Evento'

    expect(page).to have_content 'Evento reativado com sucesso'
    expect(page).not_to have_button 'Reativar Evento'
    expect(page).to have_button 'Desativar Evento'
  end

  it 'de não tem nenhum evento desativado' do
    venue = create :venue
    create :event, name: 'Aniversário', venue: venue, status: :active

    login_as venue.user, scope: :user
    visit deactivated_venue_events_path(venue.id)

    expect(page).to have_content 'Nenhum evento desativado'
  end
end
