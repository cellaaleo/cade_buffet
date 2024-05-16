require 'rails_helper'

describe "Dono de buffet edita status de um evento" do
  it "e evento fica desativado" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "...", payment_methods: "..", user: user, status: :active)
    first_event = Event.create!(name: 'Festas de Aniversário', description: '...', menu: '...', duration: 240, 
                                minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                status: :active)

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Festas de Aniversário'
    click_on 'Desativar evento'

    # Assert
    expect(page).to have_content 'Evento desativado com sucesso.'
    expect(page).to have_button 'Reativar evento'
    expect(page).not_to have_button 'Desativar evento'
  end

  it "e evento não aparece na relação de eventos que realiza" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "...", payment_methods: "..", user: user, status: :active)
    first_event = Event.create!(name: 'Festas de Aniversário', description: '...', menu: '...', duration: 240, 
                                minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                status: :active)
    second_event = Event.create!(name: 'Festas de Halloween', description: '...', menu: '...', duration: 240, 
                                  minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                  status: :active)
    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Festas de Aniversário'
    click_on 'Desativar evento'
    click_on 'Cadê Buffet?'

    # Assert
    expect(page).not_to have_content 'Festas de Aniversário'
    expect(page).to have_content 'Festas de Halloween'
  end
end
