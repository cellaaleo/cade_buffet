require 'rails_helper'

describe 'Usuário altera status do buffet' do
  it 'e o buffet fica inativo' do
    venue = create :venue, status: :active

    login_as venue.user, scope: :user
    visit root_path
    click_on 'Desativar Buffet'

    expect(page).to have_content 'Buffet desativado com sucesso'
    expect(page).to have_button 'Reativar Buffet'
    expect(page).not_to have_button 'Desativar Buffet'
  end

  it 'e não aparece para visitantes na página inicial' do
    first_user = create :user
    second_user = create :user
    create :venue, brand_name: 'Primeiro Buffet', user: first_user, status: :inactive
    create :venue, brand_name: 'Segundo Buffet', user: second_user, status: :active

    visit root_path

    expect(page).not_to have_content 'Primeiro Buffet'
    expect(page).to have_content 'Segundo Buffet'
  end

  it 'e não aparece no resultado de uma busca' do
    create :venue, brand_name: 'Primeiro Buffet', status: :inactive

    visit root_path
    fill_in 'Buscar buffet', with: 'Primeiro Buffet'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum buffet encontrado'
  end

  it 'e o buffet fica ativo' do
    venue = create :venue, status: :inactive

    login_as venue.user, scope: :user
    visit root_path
    click_on 'Reativar Buffet'

    expect(page).to have_content 'Buffet reativado com sucesso'
    expect(page).not_to have_button 'Reativar Buffet'
    expect(page).to have_button 'Desativar Buffet'
  end
end
