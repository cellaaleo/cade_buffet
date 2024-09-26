require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    User.create!(email: 'dono_buffet@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail',	with: 'dono_buffet@email.com'
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
    user = User.create!(email: 'dono_buffet@email.com', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
    within('nav') do
      expect(page).to have_link 'Criar uma conta'
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
    end
  end

  it 'e não pode se autenticar como cliente' do
    User.create!(email: 'dono_buffet@email.com', password: 'password')

    visit new_customer_session_path
    fill_in 'E-mail',	with: 'dono_buffet@email.com'
    fill_in 'Senha',	with: 'password'
    within('main form') do
      click_on 'Entrar'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).to have_link 'Cadastre-se como cliente'
  end
end
