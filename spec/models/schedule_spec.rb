require 'rails_helper'

RSpec.describe Schedule, type: :model do
  subject { build(:schedule) }

  describe 'validations' do
    it { should validate_presence_of(:shop_id) }
    it { should validate_presence_of(:day) }
    it { should validate_inclusion_of(:day).in_array(Schedule.days.keys) }
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
      should validate_numericality_of(:closing_time).is_greater_than_or_equal_to(subject.opening_time)
    end

    it 'validates that shop_id is associated with an existing shop' do
      should validate_presence_of(:shop)
    end

    it 'validates that opening_time and closing_time are not overlaping with an existing schedule for the same day and shop_id' do
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop_id: 1)
      should allow_value('13:00').for(:opening_time).with_message('overlaps with an existing schedule')
      should allow_value('18:00').for(:closing_time).with_message('overlaps with an existing schedule')
      should_not allow_value('10:00').for(:opening_time).with_message('overlaps with an existing schedule')
      should_not allow_value('11:00').for(:closing_time).with_message('overlaps with an existing schedule')
    end
  end

  describe 'associations' do
    it { should belong_to(:shop) }
  end
end
