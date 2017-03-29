class DashboardController < ApplicationController
  before_action :authenticate_user!

  def main
    @month = 1.month.ago
    @user = current_user
    artists = @user.top_artists_for_month(@month)
    # TODO: EXTRACT THIS
    @formatted_artists = artists.map do |artist|
      {
        name: artist.artist.name,
        artist_id: artist.artist_id,
        play_count: artist.play_count,
        image: artist.image,
        month: artist.month,
        give_to_url: artist.artist.give_to_url,
        give_to_verified: artist.artist.give_to_verified
      }
    end
    @top_artists = { month: format_month_year(@month), artists: @formatted_artists }
  end
end
