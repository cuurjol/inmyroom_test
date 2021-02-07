5.times do
  warehouse = Warehouse.create(name: Faker::Company.name, address: Faker::Address.full_address, balance: 0)
  methods = %i[dish fruits spice sushi vegetables]
  10.times do |i|
    Product.create(name: "#{Faker::Food.send(methods.sample)} #{i + 1}", quantity: rand(1..25),
                   price: rand(10..100.0).floor(2), warehouse: warehouse)
  end
end
