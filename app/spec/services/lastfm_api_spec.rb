require 'rails_helper'
RSpec.describe LastfmApi do
  context '#get_recent_tracks' do
    let(:user) { FactoryGirl.build(:user) }

    it 'returns a lastfm api response' do
      VCR.use_cassette('lastfm_user.getrecenttracks') do
        api = LastfmApi.new
        expect(api.get_recent_tracks(user)).to be_a Hash
      end
    end
  end

  context '#get_top_artists' do
    let(:user) { FactoryGirl.build(:user) }
    let(:result) do
      VCR.use_cassette('lastfm_user.gettopartists') do
        api = LastfmApi.new
        api.get_top_artists(user)
      end
    end

    it 'returns a lastfm api response' do
      expect(result).to be_a Hash
    end
  end
end
