FactoryGirl.define do
  factory :authentication do
    provider 'lastfm'
    uid 'beepboop'
    token 'foo'
    token_secret 'bar'
    user
  end
end
