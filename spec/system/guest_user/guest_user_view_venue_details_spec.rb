require 'rails_helper'

describe 'usuário não autenticado vê detalhes de um buffet' do
  it 'a partir da página inicial' do
    create :venue, brand_name: 'Minas Buffet & Eventos', corporate_name: 'Segundo Buffet SA',
                   registration_number: '22.222.222/0002-20', address: 'Rua dos Timbiras, 2500',
                   district: 'Barro Preto', city: 'Belo Horizonte', state: 'MG', zip_code: '30140-000',
                   email: 'eventos@second.com', phone_number: '(31)99220-9292',
                   description: 'Espaço ideal para casamentos, aniversários, entre outras ocasiões especiais'

    visit root_path
    click_on 'Minas Buffet & Eventos'
    # Assert
    expect(page).to have_content 'Minas Buffet & Eventos'
    expect(page).to have_content 'Barro Preto - Belo Horizonte/MG - CEP: 30140-000'
    expect(page).to have_content 'CNPJ: 22.222.222/0002-20'
    expect(page).to have_content 'Espaço ideal para casamentos, aniversários, entre outras ocasiões especiais'
    expect(page).to have_content 'email: eventos@second.com'
    expect(page).to have_content 'tel.: (31)99220-9292'
    expect(page).not_to have_content 'Segundo Buffet SA'
    expect(page).not_to have_link 'Cadastrar um evento'
  end

  it 'e o buffet não tem foto cadastrada' do
    venue = create :venue

    visit venue_path(venue.id)

    expect(page).not_to have_css('img')
  end

  it 'e o buffet tem foto cadastrada' do
    venue = create :venue
    venue.photo.attach(io: Rails.root.join('spec/support/foto_de_buffet.jpg').open, filename: 'foto_de_buffet.jpg')

    visit venue_path(venue.id)

    expect(page).to have_css('img')
  end
end
