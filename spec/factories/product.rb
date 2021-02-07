FactoryBot.define do
  factory :product do
    association :warehouse

    name { Faker::Food.fruits }
    quantity { rand(1..25) }
    price { rand(10..100.0).floor(2) }
  end
end
