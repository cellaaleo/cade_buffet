require 'rails_helper'

describe "Cliente se autentica" do
  it "com sucesso" do
    # Arrange - fazer cadastro
    Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")

    # Act - fazer log in
    visit root_path
    click_on "Entrar"
    click_on 'Cliente'
    fill_in "E-mail",	with: "luis@email.com"
    fill_in "Senha",	with: "password"
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
    Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")

    # Act
    visit root_path
    click_on "Entrar"
    click_on 'Cliente'
    fill_in "E-mail",	with: "luis@email.com"
    fill_in "Senha",	with: "password"
    within('main form') do
      click_on "Entrar"
    end
    click_on 'Sair'

    # Assert
    within('nav') do
      expect(page).to have_link 'Criar uma conta'
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
    end
    expect(page).to have_content 'Logout efetuado com sucesso'
  end

  it "como dono de buffet" do
     # Arrange - fazer cadastro
     Customer.create!(name: 'Luis', cpf: '197.424.430-09', email: "luis@email.com", password: "password")

     # Act
     visit root_path
     click_on "Entrar"
     click_on 'Dono de Buffet'
     fill_in "E-mail",	with: "luis@email.com"
     fill_in "Senha",	with: "password"
     within('main form') do
       click_on "Entrar"
     end
 
     # Assert
     expect(page).to have_content 'E-mail ou senha inválidos'
  end
  
end
