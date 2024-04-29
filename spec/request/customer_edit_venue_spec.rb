require 'rails_helper'

RSpec.describe "Usuário edita buffet", type: :request do
  it "e não tem autorização" do
    user = User.create!(email: "first@email.com", password: "password")
    venue = Venue.create!(brand_name: "Pinheiros Hall", corporate_name: "Primeiro Buffet Ltda", 
                                registration_number: "11.111.1111/0001-10", address: "Rua dos Pinheiros, 1001",
                                district: "Pinheiros", city: 'São Paulo', state: "SP", zip_code: "05422-000", 
                                email: "eventos@first.com", phone_number: "(11)99110-9191", user: user)
    customer = Customer.create!(name: 'Jose', cpf: '673.337.860-48', email: 'jose@email.com', password: 'password')
    
    # Act - fazer log in
    login_as(customer, scope: :customer)
    patch(venue_path(venue.id), params: {venue: {phone_number: '(31)99220-9292'}})

    # Assert - cair na página do buffet
    expect(response).to redirect_to(new_user_session_path)
  end 
end