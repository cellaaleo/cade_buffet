require 'rails_helper'

describe 'Dono de Buffet registra tipo de evento' do
  it 'se estiver autenticado' do
    venue = create :venue

    visit new_venue_event_path(venue.id)

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir da página do seu buffet' do
    venue = create :venue

    login_as venue.user, scope: :user
    visit venue_path(venue.id)
    within('main') do
      click_on 'Cadastrar um evento'
    end

    expect(current_path).to eq new_venue_event_path(venue.id)
    expect(page).to have_content 'Cadastre um tipo de evento'
    expect(page).to have_unchecked_field 'Bebidas alcoólicas'
    expect(page).to have_unchecked_field 'Decoração'
    expect(page).to have_unchecked_field 'Estacionamento'
    expect(page).to have_unchecked_field 'Valet'
    expect(page).to have_unchecked_field 'Catering'
  end

  it 'com sucesso' do
    venue = create :venue

    login_as venue.user, scope: :user
    visit new_venue_event_path(venue.id)

    fill_in 'Nome do evento',	with: 'Chá Bar'
    fill_in 'Descrição',	with: 'Pequena celebração pré-casamento...'
    fill_in 'Quantidade mínima de convidados',	with: '60'
    fill_in 'Quantidade máxima de convidados',	with: '100'
    fill_in 'Tempo de duração padrão',	with: '240'
    fill_in 'Cardápio',	with: 'Entradas e Petiscos (...) Pratos Principais (...)'
    page.check 'event_has_alcoholic_drinks'
    page.check 'event_has_parking_service'
    page.check 'event_has_decorations'
    click_on 'Enviar'

    expect(current_path).to eq event_path(venue.events.last)
    expect(page).to have_content 'Evento cadastrado com sucesso'
    expect(page).to have_content 'Chá Bar'
    expect(page).to have_content 'Pequena celebração pré-casamento...'
    expect(page).to have_content 'Entradas e Petiscos (...) Pratos Principais (...)'
    expect(page).to have_content 'mín. 60 | máx. 100 convidados'
    expect(page).to have_content 'bebidas alcoólicas'
    expect(page).to have_content 'estacionamento'
    expect(page).to have_content 'decoração'
    expect(page).not_to have_content 'valet'
    expect(page).not_to have_content 'catering'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
  end

  it 'com dados incompletos' do
    venue = create :venue

    login_as venue.user, scope: :user
    visit new_venue_event_path(venue.id)
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar Evento'
    expect(page).to have_content 'Cadastre um tipo de evento'
    expect(page).to have_content 'Verifique os erros abaixo'
    expect(page).to have_content 'Nome do evento não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima de convidados não pode ficar em branco'
    expect(page).to have_content 'Tempo de duração padrão (em minutos) não pode ficar em branco'
  end

  it 'e aparece na página do seu buffet' do
    venue = create :venue
    create :event, name: 'Eventos corporativos', venue: venue
    create :event, name: 'Aniversários', venue: venue

    login_as venue.user, scope: :user
    visit venue_path(venue.id)

    expect(page).to have_content 'Eventos que realizamos:'
    expect(page).to have_link 'Eventos corporativos'
    expect(page).to have_link 'Aniversários'
  end

  it 'e não vê eventos de outros buffets' do
    first_venue = create :venue
    second_venue = create :venue
    create :event, name: 'Festa de 15 Anos', venue: first_venue
    create :event, name: 'Formatura', venue: second_venue

    login_as first_venue.user, scope: :user
    visit venue_path(first_venue.id)

    expect(page).to have_link 'Festa de 15 Anos'
    expect(page).not_to have_link 'Formatura'
  end
end
