require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.feature 'Dashboard - Monthly Top Artists', type: :feature do
  before do
    # Stub time + Omniauth
    travel_to Time.new(2016, 6, 15).utc
    stub_omniauth
    # Log in
    visit root_path
    VCR.use_cassette 'lastfm_user_getrecenttracks_dash' do
      click_link 'Sign in with last.fm'
    end
  end
  # after(:all) { travel_back } # Should be stubbing when needed time ayways

  xscenario "User sees the previous month's top artists on their dashboard" do
    expect(page).to have_content 'Top Artists for May 2016'
  end

  xscenario 'Top Artists are ordered descending by play_count' do
    play_counts = page.all('.play-count')
    play_counts = play_counts.map do |play_count|
      play_count.text.match(/\w+:\s(\d+)$/)[1].to_i
    end
    sorted_play_counts = play_counts.sort.reverse
    expect(play_counts).to eq(sorted_play_counts)
  end
end
