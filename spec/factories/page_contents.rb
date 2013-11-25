
FactoryGirl.sequence :title do |n|
  "Title #{n}"
end

FactoryGirl.sequence :content do |n|
  "Content #{n}"
end

FactoryGirl.define do
  factory :page_content do
    title { Factory.next(:title) }
    content { Factory.next(:title) }
    page_id 1
    user_id 1
  end
end
