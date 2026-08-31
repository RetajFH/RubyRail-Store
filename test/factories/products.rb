FactoryBot.define do
  factory :product do
    name { "Shirt" }
    price { 25 }
    inventory_count { 10 }
    sizes { "S, M, L" }

    trait :out_of_stock do 
      inventory_count { 0 }
    end
  end
  
end