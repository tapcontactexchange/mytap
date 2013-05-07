FactoryGirl.define do
  
  factory :zap_card do
    firstName "Bill"
    lastName  "Tapper"
    company   "Tap.com"
    title     "CEO"

    street    "123 Maple St."
    city      "Anytown"
    state     "TX"
    zip       "67890"
    country   "USA"

    home      "555-555-5555"
    iPhone    "+1-777-777-7777"
    mobile    "858-555-5522"
    companyMain "666-666-6666"

    homeEmail "tapper@example.com"
    workEmail "tapper@tap.com"
  end
end