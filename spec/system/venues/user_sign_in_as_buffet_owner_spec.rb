require 'rails_helper'

describe 'Usuário dono de buffet faz login' do
  it 'e não tem buffet cadastrado' do
    user = create :user

    visit root_path
    login(user)

    expect(current_path).to eq new_venue_path
    expect(page).not_to have_link 'Editar dados do Buffet'
  end

  it 'e tem buffet cadastrado' do
    user = create :user
    create :venue, brand_name: 'Buffet & Eventos', user: user

    visit root_path
    login(user)

    expect(current_path).to eq venue_path(user.venue.id)
    expect(page).to have_link 'Editar dados do Buffet'
    expect(page).to have_content 'Buffet & Eventos'
  end

  it 'e tenta visualizar outro buffet' do
    first_user = create :user
    second_user = create :user
    first_venue = create :venue, brand_name: 'Primeiro Buffet', user: first_user
    second_venue = create :venue, brand_name: 'Segundo Buffet', user: second_user

    login_as first_user, scope: :user
    visit venue_path(second_venue.id)

    expect(current_path).to eq venue_path(first_venue.id)
    expect(page).to have_content 'Acesso não permitido'
    expect(page).to have_content 'Primeiro Buffet'
    expect(page).not_to have_content 'Segundo Buffet'
  end

  it 'e não tem nenhum evento cadastrado' do
    user = create :user
    create :venue, user: user

    login_as user, scope: :user
    visit root_path

    expect(page).to have_content 'Nenhum evento cadastrado'
    expect(page).to have_link 'Cadastrar um evento'
  end
end
