FactoryGirl.define do

  factory :monthly_top_artist do
    artist
    user
    # artist_id 1
    # user_id 1
    sequence(:play_count) { |n| 50 + n }
    # month 1.month.ago
  end

  factory :last_month_top_artist, class: MonthlyTopArtist do
    artist
    user
    # artist_id 1
    # user_id 1
    sequence(:play_count) { |n| 50 + n }
    month 1.month.ago
  end

  factory :this_month_top_artist, class: MonthlyTopArtist do
    artist
    user
    sequence(:play_count) { |n| 50 + n }
    month 0.months.ago
  end
end
