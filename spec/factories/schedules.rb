FactoryBot.define do
  factory :schedule do
    day { %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample }
    opening_time { (Time.zone.parse('08:00') + rand(4).hours).strftime('%H:%M') }
    closing_time { (Time.zone.parse('13:00') + rand(9).hours).strftime('%H:%M') }
    association :shop
  end
end
