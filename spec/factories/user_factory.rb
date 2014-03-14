FactoryGirl.define do

  factory :user do

    sequence(:name) {|n| "Andy Warhol #{n}" }
    sequence(:email) {|n| "andy#{n}@factory.com" }

    password "changeme"
    password_confirmation { |usr| usr.password }
  end
end


