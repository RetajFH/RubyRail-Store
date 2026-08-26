# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

User.find_or_create_by!(email_address: "admin@gmail.com") do |user|
  user.password = "123456"
  user.password_confirmation = "123456"
  user.role = "admin"
end

bakery_products = [
  {
    name: "French Butter Croissant",
    price: 12.0,
    inventory_count: 40,
    sizes: "Small,Medium,Large",
    image: "croissant.jpg"
  },
  {
    name: "Deluxe Chocolate Cake",
    price: 65.0,
    inventory_count: 15,
    sizes: "6 people,10 people",
    image: "chocolate_cake.webp"
  },
  {
    name: "Americano",
    price: 14.0,
    inventory_count: 100,
    sizes: "Small,Medium,Large",
    image: "americano.jpg"
  },
  {
    name: "Iced Latte",
    price: 18.0,
    inventory_count: 80,
    sizes: "Medium,Large",
    image: "iced_latte.jpg"
  },
  {
    name: "Berry Cheesecake",
    price: 22.0,
    inventory_count: 25,
    sizes: "Slice,Whole",
    image: "cheesecake.jpg"
  },
  {
    name: "Date Maamoul",
    price: 30.0,
    inventory_count: 20,
    sizes: "Small box,Large box",
    image: "maamoul.jpg"
  },
  {
    name: "Mixed Baklava",
    price: 45.0,
    inventory_count: 18,
    sizes: "Half kilo,Full kilo",
    image: "baklava.jpg"
  },
]

bakery_products.each do |attrs|
  product = Product.find_or_create_by!(name: attrs[:name]) do |p|
    p.price = attrs[:price]
    p.inventory_count = attrs[:inventory_count]
    p.sizes = attrs[:sizes]
  end

  image_path = Rails.root.join("db", "seed_images", attrs[:image])
  if attrs[:image] && File.exist?(image_path) && !product.featured_image.attached?
    product.featured_image.attach(
      io: File.open(image_path),
      filename: attrs[:image]
    )
  end
end

puts "✅ #{Product.count} products created"

cities = [
  "Jeddah",
  "Makkah",
  "Riyadh"
]

cities.each do |name|
  City.find_or_create_by!(name: name)
end

puts "✅ #{City.count} City created"

product = Product.find_or_create_by!(
  name: "French Butter Croissant"
) do |p|
  p.price = 14.00
  p.inventory_count = 20
  p.sizes = ["Small,Medium,Large"]
end
product.cities = [
  City.find_by!(name: "Jeddah"),
  City.find_by!(name: "Makkah")
]

puts "✅ cities added to Butter Croissant"
