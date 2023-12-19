# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  subject(:schedule) { build(:schedule) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:shop_id) }
    it { is_expected.to validate_presence_of(:day) }

    it { is_expected.to validate_presence_of(:opening_time) }
    it { is_expected.to validate_presence_of(:closing_time) }

    it 'validates the format of opening_time' do
      expect(schedule).to allow_value('08:00').for(:opening_time)
      expect(schedule).not_to allow_value('invalid_format').for(:opening_time)
      expect(schedule).not_to allow_value('45:05').for(:opening_time)
      expect(schedule).not_to allow_value('12:75').for(:opening_time)
    end

    it 'validates the format of closing_time' do
      expect(schedule).to allow_value('18:00').for(:closing_time)
      expect(schedule).not_to allow_value('invalid_format').for(:closing_time)
      expect(schedule).not_to allow_value('45:05').for(:closing_time)
      expect(schedule).not_to allow_value('12:75').for(:closing_time)
    end

    it 'validates that opening_time is before closing_time' do
      schedule.opening_time = '08:00'
      schedule.closing_time = '07:00'

      expect(schedule).not_to be_valid
    end

    it 'validates that shop_id is associated with an existing shop' do
      schedule = build(:schedule, shop_id: 999)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:shop_id]).to include('Must belong to an existing shop')
      create(:shop, id: 1)
      schedule = build(:schedule, shop_id: 1)
      expect(schedule).to be_valid
    end

    it 'validates that opening_time and closing_time are not overlaping with an existing schedule for the same day and shop_id' do
      shop = create(:shop, id: 1)
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop_id: 1)

      # Test avec un opening_time qui se chevauche
      overlapping_schedule = build(:schedule, day: 'Monday', opening_time: '10:00', closing_time: '14:00', shop: shop)
      expect(overlapping_schedule).not_to be_valid
      expect(overlapping_schedule.errors[:opening_time]).to include('overlaps with an existing schedule')

      # Test avec un opening_time qui ne se chevauche pas
      non_overlapping_schedule = build(:schedule, day: 'Monday', opening_time: '14:00', closing_time: '18:00',
                                                  shop: shop)
      expect(non_overlapping_schedule).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:shop) }
  end
end
