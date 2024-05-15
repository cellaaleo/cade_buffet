require 'rails_helper'

describe "Usuário dono de buffet cria sua conta" do
  it "e deve cadastrar um buffet" do
    # Arrange 
    # Act - cria conta
    visit root_path
    click_on "Criar uma conta"
    click_on 'Dono de Buffet'
    fill_in "E-mail",	with: "buffet@buffet.com.br"
    fill_in "Senha",	with: "password"
    fill_in "Confirme sua senha",	with: "password"
    click_on "Criar conta"

    # Assert - encaminhado à página de registro do buffet
    expect(current_path).to eq new_venue_path
    expect(page).to have_content 'Cadastre o seu buffet'
    expect(page).to have_field "Nome fantasia"
    expect(page).to have_field "CNPJ"
    expect(page).to have_field "Bairro"
    expect(page).to have_field "Telefone"
    expect(page).to have_field "Opções de pagamento"
    expect(page).to have_button "Enviar"
  end

  it 'e cadastra um buffet com sucesso' do
    # Arrange 

    # Act
    visit root_path
    click_on "Criar uma conta"
    click_on 'Dono de Buffet'
    fill_in "E-mail",	with: "buffet@buffet.com.br"
    fill_in "Senha",	with: "password"
    fill_in "Confirme sua senha",	with: "password"
    click_on "Criar conta"
    fill_in "Nome fantasia", with: "Buffet & Eventos"
    fill_in "Razão Social", with: "Buffet e Eventos Ltda"
    fill_in "CNPJ", with: "25222555/0002-05"
    fill_in "Endereço", with: "Rua Vergueiro, 555"
    fill_in "Bairro", with: "Vila Mariana"
    fill_in "Cidade", with: "Sâo Paulo"
    fill_in "Estado", with: "SP"
    fill_in "CEP", with: "02255-025"
    fill_in "Telefone", with: "95522-2255"
    fill_in "E-mail",	with: "atendimento@buffet.com.br"
    fill_in "Descrição", with: ''
    fill_in "Opções de pagamento", with: ''
    click_on "Enviar"

    # Assert
    expect(page).to have_content 'Buffet cadastrado com sucesso'
    expect(page).to have_content 'Buffet & Eventos'
    expect(page).to have_content 'Buffet e Eventos Ltda'
    expect(page).to have_content 'Vila Mariana - Sâo Paulo/SP'
    expect(page).to have_content 'atendimento@buffet.com.br'
  end


  it 'e cadastra um buffet com dados incompletos' do
    # Arrange 

    # Act
    visit root_path
    click_on "Criar uma conta"
    click_on 'Dono de Buffet'
    fill_in "E-mail",	with: "buffet@buffet.com.br"
    fill_in "Senha",	with: "password"
    fill_in "Confirme sua senha",	with: "password"
    click_on "Criar conta"
    fill_in "Nome fantasia", with: "Buffet & Eventos"
    fill_in "Razão Social", with: "Buffet e Eventos Ltda"
    fill_in "CNPJ", with: ""
    fill_in "Endereço", with: ""
    fill_in "Bairro", with: ""
    fill_in "Cidade", with: "Sâo Paulo"
    fill_in "Estado", with: "SP"
    fill_in "CEP", with: ""
    fill_in "Telefone", with: ""
    fill_in "E-mail",	with: "atendimento@buffet.com.br"
    fill_in "Descrição", with: ''
    fill_in "Opções de pagamento", with: ''
    click_on "Enviar"

    # Assert
    expect(page).to have_content 'Não foi possível cadastrar o seu buffet'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
  end

end
