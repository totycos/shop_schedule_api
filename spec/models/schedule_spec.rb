# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  subject(:schedule) { build(:schedule) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:shop_id) }
    it { is_expected.to validate_presence_of(:day) }

    it { is_expected.to validate_presence_of(:opening_time) }
    it { is_expected.to validate_presence_of(:closing_time) }

    it { is_expected.to allow_value('08:00').for(:opening_time) }
    it { is_expected.not_to allow_value('invalid_format').for(:opening_time) }
    it { is_expected.not_to allow_value('45:05').for(:opening_time) }
    it { is_expected.not_to allow_value('12:75').for(:opening_time) }

    it { is_expected.to allow_value('12:00').for(:closing_time) }
    it { is_expected.not_to allow_value('invalid_format').for(:closing_time) }
    it { is_expected.not_to allow_value('45:05').for(:closing_time) }
    it { is_expected.not_to allow_value('12:75').for(:closing_time) }

    context 'when opening_time is later than closing_time' do
      let(:schedule) { build(:schedule, opening_time: '08:00', closing_time: '07:00') }

      it 'is not valid' do
        expect(schedule).not_to be_valid
      end
    end

    context 'when shop_id does not belong to an existing shop' do
      let(:schedule) { build(:schedule, shop_id: 999) }

      it 'is not valid' do # rubocop:disable RSpec/MultipleExpectations
        expect(schedule).not_to be_valid
        expect(schedule.errors[:shop_id]).to include('Must belong to an existing shop')
      end
    end

    context 'when shop_id belongs to an existing shop' do
      before { create(:shop, id: 1) }

      let(:schedule) { build(:schedule, shop_id: 1) }

      it { is_expected.to be_valid }
    end

    context 'when opening_time and closing_time overlap with an existing schedule for the same day and shop_id' do
      let(:shop) { create(:shop, id: 1) }
      let(:overlapping_schedule) do
        build(:schedule, day: 'Monday', opening_time: '10:00', closing_time: '14:00', shop: shop)
      end
      let(:non_overlapping_schedule) do
        build(:schedule, day: 'Monday', opening_time: '14:00', closing_time: '18:00', shop: shop)
      end

      it 'has at least 1 error on :opening_time with message "overlaps with an existing schedule"' do # rubocop:disable RSpec/MultipleExpectations
        create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: shop)

        expect(overlapping_schedule).not_to be_valid
        expect(overlapping_schedule.errors[:opening_time]).to include('overlaps with an existing schedule')
      end

      it 'is valid for non_overlapping_schedule' do
        expect(non_overlapping_schedule).to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:shop) }
  end
end
