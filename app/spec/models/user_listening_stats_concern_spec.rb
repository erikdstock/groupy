RSpec.describe 'ListeningStats Concern' do
  before(:all) { travel_to Time.new(2016, 6, 2).utc }
  after(:all) { travel_to Time.now.utc }

  describe '#fetch_top_artists_by_period' do
    context 'using lastFm api' do
      let(:result) do
        VCR.use_cassette('lastfm_fetch_top_artists', record: :once, match_requests_on: %i(host path)) do
          user = build :user
          time_range = time_range_month(1.month.ago)
          user.fetch_top_artists_by_period(
            from: time_range.first,
            to: time_range.last.utc
          )
        end
      end

      it 'returns a Hash with proper structure' do
        expect(result).to be_a(Hash)
        result.each do |key, val|
          expect(key).to be_a(String)
          expect(val).to be_a(Hash)
          expect(val[:image]).to be_a(String)
          expect(val[:play_count]).to be_a(Integer)
        end
      end
    end
  end
end
