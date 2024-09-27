require 'rails_helper'

describe 'usuário não autenticado visita página inicial' do
  it 'e vê o nome da app' do
    visit root_path

    expect(page).to have_content 'Cadê Buffet?'
    within('nav') do
      expect(page).to have_link 'Criar uma conta'
      expect(page).to have_link 'Entrar'
    end
  end

  it 'e vê lista de buffets cadastrados' do
    create :venue, brand_name: 'Primeiro Buffet', city: 'São Paulo', state: 'SP'
    create :venue, brand_name: 'Segundo Buffet', city: 'Belo Horizonte', state: 'MG'
    create :venue, brand_name: 'Terceiro Buffet', city: 'Fortaleza', state: 'CE'

    visit root_path

    expect(page).to have_content 'Lista de Buffets'
    expect(page).to have_content 'Primeiro Buffet - São Paulo/SP'
    expect(page).to have_content 'Segundo Buffet - Belo Horizonte/MG'
    expect(page).to have_content 'Terceiro Buffet - Fortaleza/CE'
  end
end
