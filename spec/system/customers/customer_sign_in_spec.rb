require 'rails_helper'

describe 'Cliente se autentica' do
  it 'com sucesso' do
    create :customer, email: 'luis@email.com', password: 'password'

    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    fill_in 'E-mail',	with: 'luis@email.com'
    fill_in 'Senha',	with: 'password'
    within('main form') do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso'
    within('nav') do
      expect(page).not_to have_link 'Criar sua conta'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
  end

  it 'e faz log out' do
    customer = create :customer, email: 'luis@email.com', password: 'password'

    login_as customer, scope: :customer
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
    within('nav') do
      expect(page).to have_link 'Criar uma conta'
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
    end
  end

  it 'e não pode se autenticar como dono de buffet' do
    create :customer, email: 'luis@email.com', password: 'password'

    visit new_user_session_path
    fill_in 'E-mail',	with: 'luis@email.com'
    fill_in 'Senha',	with: 'password'
    within('main form') do
      click_on 'Entrar'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).to have_content 'Cadastre-se como buffet'
  end
end
