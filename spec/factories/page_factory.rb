FactoryGirl.define do

  factory :page do
    sequence(:original_title) {|n| "Post Title #{n}" }
  end
end