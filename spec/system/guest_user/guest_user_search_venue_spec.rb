require 'rails_helper'

describe 'Usuário não autenticado busca um buffet' do
  it 'a partir do menu' do
    visit root_path

    within('header nav form') do
      expect(page).to have_field 'Buscar buffet'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'pelo nome fantasia ou cidade' do
    create :venue, brand_name: 'Pinheiros Hall', city: 'São Paulo', state: 'SP'
    create :venue, brand_name: 'Buffet São Paulo', city: 'Belo Horizonte', state: 'MG'
    create :venue, brand_name: 'Buffet do Vale', city: 'Fortaleza', state: 'CE'

    visit root_path
    fill_in 'Buscar buffet', with: 'são paulo'
    click_on 'Buscar'

    expect(page).to have_content "Resultado da busca por: 'são paulo'"
    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_text(:all, 'Buffet São Paulo - Belo Horizonte/MG Pinheiros Hall - São Paulo/SP')
    expect(page).not_to have_content 'Buffet do Vale'
  end

  it 'pelo tipo de evento que oferece' do
    first_venue = create :venue, brand_name: 'Pinheiros Hall', city: 'São Paulo', state: 'SP'
    second_venue = create :venue, brand_name: 'Casamento Mineiro Buffet', city: 'Belo Horizonte', state: 'MG'
    third_venue = create :venue, brand_name: 'Buffet do Vale', city: 'Fortaleza', state: 'CE'

    create :event, name: 'Eventos corporativos', venue: first_venue
    create :event, name: 'Casamento', venue: second_venue
    create :event, name: 'Casamento', venue: third_venue

    visit root_path
    fill_in 'Buscar buffet', with: 'casamento'
    click_on 'Buscar'

    expect(page).to have_content "Resultado da busca por: 'casamento'"
    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_text(:all, 'Buffet do Vale - Fortaleza/CE Casamento Mineiro Buffet - Belo Horizonte/MG')
    expect(page).not_to have_content 'Pinheiros Hall'
  end

  it 'e vê detalhes de um buffet' do
    venue = create :venue, brand_name: 'Buffet São Paulo', city: 'Belo Horizonte', state: 'MG'

    visit root_path
    fill_in 'Buscar buffet', with: 'são paulo'
    click_on 'Buscar'
    click_on 'Buffet São Paulo'

    expect(current_path).to eq venue_path(venue.id)
  end

  it 'e não encontra um buffet ativo' do
    venue = create :venue, brand_name: 'Buffet para Casamento', status: 'inactive'
    create :event, name: 'Casamento', venue: venue

    visit root_path
    fill_in 'Buscar buffet', with: 'casamento'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum buffet encontrado'
  end
end
