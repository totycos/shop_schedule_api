require 'rails_helper'

RSpec.describe Shop, type: :model do
  # spec/models/shop_spec.rb
  require 'rails_helper'

  RSpec.describe Shop, type: :model do
    context 'validations' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).case_insensitive }
      it { should_not allow_value('').for(:name) }

      context 'when a shop with the same name exists' do
        create(:shop, name: 'My Shop')
        it { should_not validate_uniqueness_of(:name).case_insensitive }
      end
    end
  end
end
