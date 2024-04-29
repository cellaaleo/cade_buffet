require 'rails_helper'

describe "Usuário se autentica" do
  it "com sucesso" do
    # Arrange - fazer cadastro
    User.create!(email: "sac@eventos.com", password: "senha123")

    # Act - fazer log in
    visit root_path
    click_on "Entrar"
    click_on 'Dono de Buffet'
    fill_in "E-mail",	with: "sac@eventos.com"
    fill_in "Senha",	with: "senha123"
    within('main form') do
      click_on "Entrar"
    end

    # Assert
    within('nav') do
      expect(page).not_to have_link 'Criar sua conta'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
    end
    expect(page).to have_content 'Login efetuado com sucesso'
  end

  it "e faz log out" do
    # Arrange - fazer cadastro
    User.create!(email: "sac@eventos.com", password: "senha123")

    # Act - fazer log in
    visit root_path
    click_on "Entrar"
    click_on 'Dono de Buffet'
    fill_in "E-mail",	with: "sac@eventos.com"
    fill_in "Senha",	with: "senha123"
    within('main form') do
      click_on "Entrar"
    end
    click_on 'Sair'

    # Assert
    within('nav') do
      expect(page).to have_link 'Criar sua conta'
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
    end
    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end
