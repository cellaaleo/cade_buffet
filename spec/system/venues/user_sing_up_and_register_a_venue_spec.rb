require 'rails_helper'

describe 'Usuário dono de buffet cria sua conta' do
  it 'e deve cadastrar um buffet' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Dono de Buffet'
    fill_in 'E-mail',	with: 'buffet@email.com.br'
    fill_in 'Senha',	with: 'password'
    fill_in 'Confirme sua senha',	with: 'password'
    click_on 'Criar conta'

    expect(current_path).to eq new_venue_path
    expect(page).to have_content 'Cadastre o seu Buffet'
  end

  it 'e cadastra um buffet com sucesso' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Dono de Buffet'
    fill_in 'E-mail',	with: 'buffet@buffet.com.br'
    fill_in 'Senha',	with: 'password'
    fill_in 'Confirme sua senha',	with: 'password'
    click_on 'Criar conta'
    fill_in 'Nome fantasia', with: 'Buffet & Eventos'
    fill_in 'Razão Social', with: 'Buffet e Eventos Ltda'
    fill_in 'CNPJ', with: '25.222.555/0002-05'
    fill_in 'Endereço', with: 'Rua Vergueiro, 555'
    fill_in 'Bairro', with: 'Vila Mariana'
    fill_in 'Cidade', with: 'Sâo Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'CEP', with: '02255-025'
    fill_in 'Telefone', with: '95522-2255'
    fill_in 'E-mail',	with: 'atendimento@buffet.com.br'
    fill_in 'Descrição', with: 'Buffet ideal para qualquer tipo de evento.'
    fill_in 'Opções de pagamento', with: 'Pix, Boleto'
    click_on 'Enviar'

    expect(current_path).to eq venue_path(Venue.last.id)
    expect(page).to have_content 'Buffet cadastrado com sucesso'
    expect(page).to have_content 'Buffet & Eventos'
    expect(page).to have_content 'Buffet e Eventos Ltda'
    expect(page).to have_content 'Vila Mariana - Sâo Paulo/SP'
    expect(page).to have_content 'atendimento@buffet.com.br'
  end

  it 'e cadastra um buffet com dados incompletos' do
    visit root_path
    click_on 'Criar uma conta'
    click_on 'Dono de Buffet'
    fill_in 'E-mail',	with: 'buffet@buffet.com.br'
    fill_in 'Senha',	with: 'password'
    fill_in 'Confirme sua senha',	with: 'password'
    click_on 'Criar conta'
    click_on 'Enviar'

    expect(page).to have_content 'Cadastre o seu Buffet:'
    expect(page).to have_content 'Não foi possível cadastrar o seu Buffet'
    expect(page).to have_content 'Verifique os erros abaixo'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
  end
end
