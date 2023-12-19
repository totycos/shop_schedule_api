# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    day { Schedule.days.keys.sample.to_s }
    opening_time { '08:00' }
    closing_time { '12:00' }
    association :shop, strategy: :create
  end
end
