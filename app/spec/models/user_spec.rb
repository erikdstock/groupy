require 'rails_helper'
include TimeTools

RSpec.describe User, type: :model do
  before(:all) { travel_to Time.new(2016, 6, 2).utc }
  after(:all) { travel_to Time.now.utc }

  def expect_valid_monthly_top_artists(monthly_top_artists, expect_empty: false)
    expect(monthly_top_artists).to be_a ActiveRecord::Relation
    expect_empty ? (expect(monthly_top_artists.length).to eq(0)) : (expect(monthly_top_artists.length).to be > 0)
  end

  describe 'associations' do
    it { should have_many :monthly_top_artists }
    it do
      should have_many(:top_artists).through(:monthly_top_artists).source(:artist)
    end
  end

  # This is the getter for a user's monthly top artists scoped by month.
  describe '#top_artists_for_month' do
    let(:user) { create(:user_with_stats) }
    let(:finalized_result) do
      user.top_artists_for_month(1.month.ago)
    end

    context 'finalized structure for good data' do
      it 'returns an AR Relation' do
        expect_valid_monthly_top_artists(finalized_result)
        expect(finalized_result.length).to eq 1
        expect(finalized_result.first.play_count).to eq 5
      end

      it 'contains monthly_top_artists data plus artist name and image attrs' do
        result = finalized_result.first
        expect { result.play_count && result.artist.name && result.artist.image }.not_to raise_error
      end
    end
  end

  # Setter for user's top artists scoped by month
  # TODO this could use more tests/edge cases? what if save fails?
  describe '#update_top_artists_for_month' do
    let(:user) { create(:user_with_stats) }
    let(:new_artists) { [] }
    context 'successful save' do
      it 'returns true' do
        expect(user.update_top_artists_for_month(new_artists, 1.month.ago)).to be true
      end

      it 'changes existing MTAs and adds new ones' do
        user = create :user_with_stats
        new_artist = create :artist
        time = 1.month.ago
        initial = user.top_artists_for_month(time)
        artist = initial.first.artist
        data = {artist.name => {play_count: 13, image: 'foo'},
                new_artist.name => {play_count: 7, image: 'bar'}}
        user.update_top_artists_for_month(data, time)
        result = user.top_artists_for_month(time)
        change = result.where(artist_id: artist.id).first.play_count - initial.first.play_count
        expect(change).to eq 8
        expect(result.length).to eq 2
      end
      # it 'returns the same AR relation that #fetch_top_artists would'
    end
    # context 'save fails' do
    #   it 'rolls back the transaction- initial artists are still there'
    #   it 'returns false'
    # end
  end
end
