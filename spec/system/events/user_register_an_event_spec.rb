require 'rails_helper'

describe "dono de buffet registra tipo de evento" do
  it 'a partir da página do seu buffet' do
    # Arrange criar usuário e buffet
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123')
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user_id: u.id)
    # Act
    visit root_path
    click_on "Entrar"
    fill_in "E-mail", with: 'tiella@email.com.br'
    fill_in "Senha", with: 'tiella123'
    within('form') do
      click_on "Entrar"
    end
    click_on 'Cadastrar tipos de evento'

    # Assert
    expect(page).to have_content 'Cadastre um tipo de evento:'
    expect(page).to have_field 'Nome do evento'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade mínima de convidados'
    expect(page).to have_field 'Quantidade máxima de convidados'
    expect(page).to have_field 'Tempo de duração padrão'
    expect(page).to have_field 'Cardápio'
    expect(page).to have_unchecked_field 'Bebidas alcoólicas'
    expect(page).to have_unchecked_field 'Decoração'
    expect(page).to have_unchecked_field 'Estacionamento'
    expect(page).to have_unchecked_field 'Valet'
    expect(page).to have_unchecked_field 'Catering'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    # Arrange
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123')
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user_id: u.id)
    # Act
    visit root_path
    click_on "Entrar"
    fill_in "E-mail", with: 'tiella@email.com.br'
    fill_in "Senha", with: 'tiella123'
    within('form') do
      click_on "Entrar"
    end
    click_on 'Cadastrar tipos de evento'
    fill_in "Nome do evento",	with: "Casamento"
    fill_in "Descrição",	with: "Festas e recepções de casamento"
    fill_in "Quantidade mínima de convidados",	with: "60"
    fill_in "Quantidade máxima de convidados",	with: "200"
    fill_in "Tempo de duração padrão",	with: "240"
    fill_in "Cardápio",	with: "Brunchs, Almoços, Jantares..."
    page.check "event_has_alcoholic_drinks"
    page.check "event_has_parking_service"
    click_on "Enviar"
    
    # Assert
    expect(page).to have_content 'Evento cadastrado com sucesso!'
    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Festas e recepções de casamento para até 200 convidados, 240 minutos de duração'
    expect(page).to have_content 'bebidas alcoólicas'
    expect(page).to have_content 'estacionamento'
    expect(page).not_to have_content 'decoração'
    expect(page).not_to have_content 'valet'
    expect(page).not_to have_content 'catering'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
    
  end
end
