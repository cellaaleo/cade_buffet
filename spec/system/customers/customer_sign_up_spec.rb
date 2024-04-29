require 'rails_helper'

describe "Cliente realiza cadastro" do
  it "com sucesso" do
    # Arrange
    # Act
    visit root_path
    click_on 'Cadastre-se para contratar um buffet'
    fill_in "Nome",	with: "Bruna"
    fill_in "CPF", with: "673.337.860-48"
    fill_in 'E-mail', with: 'bruna@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert  
    expect(current_path).to eq root_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso'
    customer = Customer.last 
    expect(customer.name).to eq 'Bruna'
    within('nav') do
      expect(page).to have_content 'Bruna - bruna@email.com' 
      expect(page).not_to have_content 'Editar dados do Buffet'
    end
  end
  
  it "com dados incompletos" do
     # Arrange
    # Act
    visit root_path
    click_on 'Cadastre-se para contratar um buffet'
    fill_in "Nome",	with: ""
    fill_in "CPF", with: ""
    fill_in 'E-mail', with: 'bruna@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert 
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
  end
  
  it "e o CPF é inválido" do
    # Arrange
    # Act
    visit root_path
    click_on 'Cadastre-se para contratar um buffet'
    fill_in "Nome",	with: "Bruna"
    fill_in "CPF", with: "111.111.111-11"
    fill_in 'E-mail', with: 'bruna@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert  
    expect(page).to have_content 'CPF inválido'
  end
  
  it "e o CPF deve ser único" do
    # Arrange
    Customer.create!(name: 'Jose', cpf: '673.337.860-48', email: 'jose@email.com', password: 'password')
    # Act
    visit root_path
    click_on 'Cadastre-se para contratar um buffet'
    fill_in "Nome",	with: "Bruna"
    fill_in "CPF", with: "673.337.860-48"
    fill_in 'E-mail', with: 'bruna@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    # Assert  
    expect(page).to have_content 'CPF já está em uso'
  end
  
end
