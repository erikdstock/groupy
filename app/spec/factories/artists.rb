FactoryGirl.define do
  factory :artist do
    sequence(:name)  { |n| "Artist #{n}" }
    image "http://www.artistpics.com/test-artist.jpg"
  end
end
