require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when event name is empty' do
        event = build :event, name: ''

        expect(event).not_to be_valid
        expect(event.errors).to include :name
      end

      it 'false when duration is empty' do
        event = build :event, duration: ''

        expect(event).not_to be_valid
        expect(event.errors).to include :duration
      end

      it 'false when minimum guests number is empty' do
        event = build :event, minimum_guests_number: ''

        expect(event).not_to be_valid
        expect(event.errors).to include :minimum_guests_number
      end

      it 'false when maximum guests number is empty' do
        event = build :event, maximum_guests_number: ''

        expect(event).not_to be_valid
        expect(event.errors).to include :maximum_guests_number
      end
    end
  end
end
