require 'rails_helper'

RSpec.describe Shop, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should_not allow_value('').for(:name) }
  end

  context 'associations' do
    it { should have_many(:schedules).dependent(:destroy) }

    it 'destroys associated schedules when shop is destroyed' do
      shop = create(:shop)
      schedule = create(:schedule, shop: shop)

      expect { shop.destroy }.to change(Schedule, :count).by(-1)
    end
  end
end
