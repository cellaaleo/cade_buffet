require 'rails_helper'

describe 'Usuário faz cadastro' do
  it 'com sucesso' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Dono de Buffet'
    fill_in 'E-mail',	with: 'atendimento@buffet.com.br'
    fill_in 'Senha',	with: 'password'
    fill_in 'Confirme sua senha',	with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Você realizou seu registro com sucesso'
    within('nav') do
      expect(page).not_to have_link 'Criar sua conta'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
  end
end
