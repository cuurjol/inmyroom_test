FactoryBot.define do
  factory :warehouse do
    name { Faker::Company.name }
    address { Faker::Address.full_address }
    balance { 0 }
  end
end
