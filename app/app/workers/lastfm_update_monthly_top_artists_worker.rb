class LastfmUpdateMonthlyTopArtistsWorker
  include Sidekiq::Worker
  include TimeTools

  # update a user's top artists for a given month
  # @param id [String] user id
  # @param month [Time] Time-like object to deduce month
  def perform(id, month)
    month = month.to_datetime
    # get time range
    time_range = time_range_month(month)
    user = User.find_by(id: id)
    if user
      # fetch new top artists for period
      new_top_artists = user.fetch_top_artists_by_period(from: time_range.first, to: time_range.last)
      # update
      user.update_top_artists_for_month(new_top_artists, month)
    end
    logger.error "could not find a user with id #{id}" unless user
  end
end
