require 'rails_helper'

describe 'Usuário não autenticado vê detalhes de um buffet' do
  it 'e vê lista de eventos que ele oferece' do
    first_venue = create :venue, brand_name: 'Pinheiros Hall'
    second_venue = create :venue, brand_name: 'Buffet do Vale'
    create :event, name: 'Festa Junina', venue: first_venue
    create :event, name: 'Halloween', venue: first_venue
    create :event, name: 'Casamento', venue: second_venue

    visit venue_path(first_venue.id)

    expect(page).to have_content 'Festa Junina'
    expect(page).to have_content 'Halloween'
    expect(page).not_to have_content 'Casamento'
    expect(page).not_to have_link 'Cadastrar um evento'
  end

  it 'e vê todos os detalhes de um evento' do
    venue = create :venue
    event = create :event, name: 'Casamento', description: 'Recepção e festa de casamento',
                           minimum_guests_number: 80, maximum_guests_number: 120, duration: 240,
                           menu: 'brunch e coffee breaks', has_valet_service: true,
                           can_be_catering: false, venue: venue
    Price.create!(weekday_base_price: 10_000, weekday_plus_per_person: 100, weekday_plus_per_hour: 1500,
                  weekend_base_price: 15_000, weekend_plus_per_person: 150, weekend_plus_per_hour: 2000,
                  event: event)

    visit venue_path(venue.id)
    click_on 'Casamento'

    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Recepção e festa de casamento'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
    expect(page).to have_content 'mín. 80 | máx. 120 convidados'
    expect(page).to have_content 'Duração média: 240 minutos'
    expect(page).to have_content 'valet'
    expect(page).to have_content 'Valor inicial R$ 10000,00 R$ 15000,00'
    expect(page).to have_content 'Taxa extra por pessoa R$ 100,00 R$ 150,00'
    expect(page).to have_content 'Taxa por hora adicional R$ 1500,00 R$ 2000,00'
    expect(page).not_to have_content 'catering'
  end
end
