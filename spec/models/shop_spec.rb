# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shop, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'associations' do
    it { is_expected.to have_many(:schedules).dependent(:destroy) }

    it 'destroys associated schedules when shop is destroyed' do
      shop = create(:shop)
      create(:schedule, shop: shop)

      expect { shop.destroy }.to change(Schedule, :count).by(-1)
    end
  end
end
