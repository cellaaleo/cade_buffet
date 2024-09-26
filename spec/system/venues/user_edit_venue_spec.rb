require 'rails_helper'

describe 'Usuário edita dados de seu buffet' do
  it 'se estiver autenticado' do
    venue = create :venue

    visit edit_venue_path(venue.id)

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir da página do buffet' do
    venue = create :venue, brand_name: 'Buffet & Eventos', registration_number: '66.666.666/0001-00'

    login_as venue.user, scope: :user
    visit root_path
    click_on 'Editar dados do Buffet'

    expect(current_path).to eq edit_venue_path(venue.id)
    expect(page).to have_content 'Editar informações de Buffet & Eventos'
    expect(page).to have_field 'Nome fantasia', with: 'Buffet & Eventos'
    expect(page).to have_field 'CNPJ', with: '66.666.666/0001-00'
  end

  it 'com sucesso' do
    venue = create :venue, brand_name: 'Nome Antigo', email: 'antigo@email.com'

    login_as venue.user, scope: :user
    visit edit_venue_path(venue.id)
    fill_in 'Nome fantasia', with: 'Nome Novo'
    fill_in 'E-mail', with: 'novo@email.com'
    click_on 'Enviar'

    expect(current_path).to eq venue_path(venue.id)
    expect(page).to have_content 'Buffet editado com sucesso'
    expect(page).to have_link 'Editar dados do Buffet'
    expect(page).not_to have_content 'Nome Antigo'
    expect(page).to have_content 'Nome Novo'
    expect(page).to have_content 'email: novo@email.com'
  end

  it 'com dados incompletos' do
    venue = create :venue, corporate_name: 'Buffet & Eventos Ltda'

    login_as venue.user, scope: :user
    visit edit_venue_path(venue.id)
    fill_in 'Nome fantasia', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Editar informações'
    expect(page).to have_content 'Não foi possível editar dados do Buffet'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_field('Nome fantasia', with: '')
    expect(page).to have_field('E-mail', with: '')
    expect(page).to have_field('Razão Social', with: 'Buffet & Eventos Ltda')
  end

  it 'e adiciona uma foto do buffet com sucesso' do
    venue = create :venue

    login_as venue.user, scope: :user
    visit edit_venue_path(venue.id)
    attach_file 'Foto do Buffet', Rails.root.join('spec/support/foto_de_buffet.jpg')
    click_on 'Enviar'

    expect(page).to have_css('img[src*="foto_de_buffet.jpg"]')
  end

  it 'e altera foto do buffet com sucesso' do
    venue = create :venue
    venue.photo.attach(io: Rails.root.join('spec/support/foto_de_buffet.jpg').open, filename: 'foto_de_um_buffet.jpg')

    login_as venue.user, scope: :user
    visit edit_venue_path(venue.id)
    attach_file 'Foto do Buffet', Rails.root.join('spec/support/foto_buffet_rustico.jpg')
    click_on 'Enviar'

    expect(page).to have_css('img[src*="foto_buffet_rustico.jpg"]')
  end
end
