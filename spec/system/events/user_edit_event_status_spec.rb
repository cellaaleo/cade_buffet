require 'rails_helper'

describe "Dono de buffet edita status de um evento" do
  it "e evento é desativado" do
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

  it "e vê relação de eventos desativados" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "...", payment_methods: "..", user: user, status: :active)
    first_event = Event.create!(name: 'Festas de Aniversário', description: '...', menu: '...', duration: 240, 
                                minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                status: :inactive)
    second_event = Event.create!(name: 'Festas de Halloween', description: '...', menu: '...', duration: 240, 
                                  minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                  status: :active)
    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver eventos desativados'

    # Assert
    expect(current_path).to eq deactivated_venue_events_path(venue.id)
    expect(page).to have_content 'Eventos desativados'
    expect(page).to have_content 'Festas de Aniversário'
    expect(page).not_to have_button 'Festas de Halloween'
  end
  

  it "e evento é reativado" do
    # Arrange
    user = User.create!(email: 'buffet@email.com', password: 'password')
    venue = Venue.create!(brand_name: "Casa Jardim", corporate_name: "Casa Jardim Buffet Ltda", registration_number:"11.111.111/0001-00",
                      address: "Rua Eugênio de Medeiros, 530", district: "Pinheiros", city: "São Paulo", state: "SP", zip_code: "05050-050", 
                      phone_number: "(11)99111-1111", email: "eventosbuffet@email.com", 
                      description: "...", payment_methods: "..", user: user, status: :active)
    first_event = Event.create!(name: 'Festas de Aniversário', description: '...', menu: '...', duration: 240, 
                                minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                status: :inactive)
    second_event = Event.create!(name: 'Festas de Halloween', description: '...', menu: '...', duration: 240, 
                                  minimum_guests_number: 50, maximum_guests_number: 100, venue: venue,
                                  status: :active)
    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver eventos desativados'
    click_on 'Festas de Aniversário'
    click_on 'Reativar evento'

    # Assert
    expect(page).to have_content 'Evento reativado com sucesso.'
    expect(page).not_to have_button 'Reativar evento'
    expect(page).to have_button 'Desativar evento'
  end
end
