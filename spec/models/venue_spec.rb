require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when brand name is empty' do
        venue = build :venue, brand_name: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :brand_name
      end

      it 'false when corporate name is empty' do
        venue = build :venue, corporate_name: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :corporate_name
      end

      it 'false when registration number is empty' do
        venue = build :venue, registration_number: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :registration_number
      end

      it 'false when address is empty' do
        venue = build :venue, address: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :address
      end

      it 'false when district is empty' do
        venue = build :venue, district: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :district
      end

      it 'false when city is empty' do
        venue = build :venue, city: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :city
      end

      it 'false when state is empty' do
        venue = build :venue, state: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :state
      end

      it 'false when zip code is empty' do
        venue = build :venue, zip_code: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :zip_code
      end

      it 'false when email is empty' do
        venue = build :venue, email: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :email
      end

      it 'false when phone number is empty' do
        venue = build :venue, phone_number: ''

        expect(venue).not_to be_valid
        expect(venue.errors).to include :phone_number
      end
    end

    context 'uniqueness' do
      it 'false when registrantion number is already in use' do
        create :venue, registration_number: '66.666.666/0001-00'
        new_venue = build :venue, registration_number: '66.666.666/0001-00'

        expect(new_venue).not_to be_valid
        expect(new_venue.errors.full_messages).to include 'CNPJ já está em uso'
      end

      it 'false when user already has a buffet' do
        user = create :user
        create :venue, user: user
        new_venue = build :venue, user: user

        expect(new_venue).not_to be_valid
        expect(new_venue.errors.full_messages).to include 'Dono / Proprietário já está em uso'
      end
    end
  end

  describe '#full_address' do
    it "shows venue's full address" do
      venue = create :venue, address: 'Rua Parambu, 585', district: 'Santa Teresa',
                             city: 'Salvador', state: 'BA', zip_code: '40265-060'

      expect(venue.full_address).to eq 'Rua Parambu, 585 - Santa Teresa - Salvador/BA - CEP: 40265-060'
    end
  end
end
