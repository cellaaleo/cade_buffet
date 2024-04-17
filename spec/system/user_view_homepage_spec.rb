require 'rails_helper'

describe "usuário vê página inicial" do
  it 'e vê o nome da app' do
    # Arrange
    # Act
    visit root_path
    # Assert
    expect(page).to have_content 'Cadê Buffet?'  
  end

  it 'e vê os links de criar conta e de fazer log in' do
    # Arrange
    # Act
    visit root_path
    # Assert
    within('nav') do
      expect(page).to have_content 'Criar sua conta'
      expect(page).to have_content 'Entrar'
    end
  end
end
