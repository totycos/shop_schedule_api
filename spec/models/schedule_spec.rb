require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:shop_id) }
    it { should validate_presence_of(:day) }
    it {
      should validate_inclusion_of(:day)
        .in?(%w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday])
    }
    it { should validate_presence_of(:opening_time) }
    it { should validate_presence_of(:closing_time) }

    it 'validates the format of opening_time' do
      should allow_value('08:00').for(:opening_time)
      should_not allow_value('invalid_format').for(:opening_time)
      should_not allow_value('45:05').for(:opening_time)
      should_not allow_value('12:75').for(:opening_time)
    end

    it 'validates the format of closing_time' do
      should allow_value('18:00').for(:closing_time)
      should_not allow_value('invalid_format').for(:closing_time)
      should_not allow_value('45:05').for(:closing_time)
      should_not allow_value('12:75').for(:closing_time)
    end

    it 'validates that opening_time is before closing_time' do
      subject.opening_time = '08:00'
      subject.closing_time = '07:00'

      expect(subject).not_to be_valid
    end

    it 'validates that shop_id is associated with an existing shop' do
      schedule = build(:schedule, shop_id: 999)
      expect(schedule).not_to be_valid
      expect(schedule.errors[:shop_id]).to include('Must belong to an existing shop')
      shop = create(:shop, id: 1)
      schedule = build(:schedule, shop_id: 1)
      expect(schedule).to be_valid
    end

    it 'validates that opening_time and closing_time are not overlaping with an existing schedule for the same day and shop_id' do
      shop = create(:shop, id: 1)
      existing_schedule = create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop_id: 1)

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
    it { should belong_to(:shop) }
  end
end
