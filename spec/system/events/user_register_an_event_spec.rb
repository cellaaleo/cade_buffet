require 'rails_helper'

describe "dono de buffet registra tipo de evento" do
  it 'a partir da página do seu buffet' do
    # Arrange criar usuário e buffet
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123', buffet_owner: true)
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    # Act
    login_as u, :scope => :user
    visit root_path
    within('main') do
      click_on 'Cadastrar um evento'
    end

    # Assert
    expect(page).to have_content 'Cadastre um tipo de evento'
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
                      payment_methods: "", user: u)
    # Act
    login_as u, :scope => :user
    visit root_path
    within('main') do
      click_on 'Cadastrar um evento'
    end
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
    expect(page).to have_content 'Festas e recepções de casamento, a partir de 60 até o máximo de 200 convidados, com pelo menos 240 minutos de duração'
    expect(page).to have_content 'bebidas alcoólicas'
    expect(page).to have_content 'estacionamento'
    expect(page).not_to have_content 'decoração'
    expect(page).not_to have_content 'valet'
    expect(page).not_to have_content 'catering'
    expect(page).to have_content 'Evento realizado exclusivamente em nosso espaço'
  end

  it "e aparece na página do seu buffet" do
    # Arrange
    u = User.create!(email: 'tiella@email.com.br', password: 'tiella123')
    v = Venue.create!(brand_name: "Tiella", corporate_name: "Tiella Eventos Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventostiella@email.com.br", 
                      description: "Salão de festas com decoração rústica e chique, vários ambientes, jardim arborizado e pista de dança.",
                      payment_methods: "", user: u)
    Event.create!(name: 'Eventos corporativos', venue: v)
    Event.create!(name: 'Aniversários', venue: v)

    # Act
    login_as u, :scope => :user
    visit root_path

    # Assert
    expect(page).to have_link 'Eventos corporativos'
    expect(page).to have_link 'Aniversários' 
  end
  
end
