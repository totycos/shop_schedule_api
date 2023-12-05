FactoryBot.define do
  factory :schedule do
    day { %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample }
    opening_time { '08:00 ' }
    closing_time { '12:00' }
    association :shop, strategy: :create
  end
end
