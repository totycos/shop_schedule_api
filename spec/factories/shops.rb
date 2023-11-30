FactoryBot.define do
  factory :shop do
    name { Faker::Company.name }

    factory :shop_with_schedules do
      transient do
        schedules_count { 3 } # Vous pouvez ajuster le nombre de schedules associés
      end

      after(:create) do |shop, evaluator|
        create_list(:schedule, evaluator.schedules_count, shop: shop)
      end
    end
  end
end
