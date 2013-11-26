FactoryGirl.define do

  factory :user do

    sequence(:name) {|n| "Andy Warhol #{n}" }
    sequence(:email) {|n| "andy#{n}@factory.com" }

    password 11111111
    password_confirmation { |usr| usr.password }
  end
end


