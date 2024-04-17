require 'rails_helper'

describe "Usuário faz cadastro" do
  it "com sucesso" do
    # Arrange

    # Act
    visit root_path
    click_on "Criar sua conta"
    fill_in "E-mail",	with: "atendimento@buffet.com.br"
    fill_in "Senha",	with: "senha123"
    fill_in "Confirme sua senha",	with: "senha123"
    click_on "Criar conta"

    # Assert
    expect(page).to have_content 'Você realizou seu registro com sucesso'
    within('nav') do
      expect(page).not_to have_link 'Criar sua conta'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
  end
end
