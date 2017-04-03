FactoryGirl.define do
  factory :user do
    password Devise.friendly_token[0, 20]
    email 'user@test.com'
    name 'erikdstock'
    after(:create) do |user, _evaluator|
      create(:authentication, user: user)
    end

    # after(:build) { |u| u.class.skip_callback(:create, :after, :queue_initial_refresh) }

    # Create a user with only 5 plays so far. At the end of this month
    # (may 2016) it should be 12 plays.
    factory :user_with_stats do
      after(:create) do |user, _evaluator|
        artist = create :artist, name: 'MisterWives'
        create(:monthly_top_artist, artist: artist, play_count: 5, user: user, month: 1.month.ago)
      end
    end
  end

  # # user_with_posts will create post data after the user has been created
  # factory :user_with_stats do
  #   # posts_count is declared as a transient attribute and available in
  #   # attributes on the factory, as well as the callback via the evaluator
  #   transient do
  #     posts_count 5
  #   end
  #
  #   # the after(:create) yields two values; the user instance itself and the
  #   # evaluator, which stores all values from the factory, including transient
  #   # attributes; `create_list`'s second argument is the number of records
  #   # to create and we make sure the user is associated properly to the post
  #   after(:create) do |user, evaluator|
  #     create_list(:post, evaluator.posts_count, user: user)
  #   end
  # end
end
