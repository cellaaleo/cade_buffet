require 'rails_helper'

describe 'Cliente realiza cadastro' do
  it 'com sucesso' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Cliente'
    fill_in 'Nome',	with: 'Bruna'
    fill_in 'CPF', with: '673.337.860-48'
    fill_in 'E-mail', with: 'bruna@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(current_path).to eq root_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso'
    within('nav') do
      expect(page).to have_content 'Bruna - bruna@email.com'
      expect(page).not_to have_content 'Editar dados do Buffet'
    end
  end

  it 'com dados incompletos' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Cliente'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar cliente: 4 erros'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end
end
