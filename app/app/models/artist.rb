class Artist < ApplicationRecord
  has_many :monthly_top_artists
  has_many :users, through: :monthly_top_artists
  after_create :queue_initial_refresh

  def queue_initial_refresh
    queue_give_to_update
    queue_lastfm_update
  end

  def queue_give_to_update(clobber: false)
    GiveToUpdateArtistInfoWorker.perform_async(id, clobber: clobber) if give_to_incomplete?
  end

  def queue_lastfm_update(clobber: true)
    # ArtistLastfmRefreshJob.perform_later(id)
    logger.warn 'not implemented'
  end

  # Update an artist's empty fields
  def update_empty_give_to_fields(data)
    logger.debug "updating #{name} with #{data}:"
    self.give_to_url ||= data[:url]
    self.give_to_verified ||= data[:verified]
    self.image ||= data[:image]
    save ? logger.debug('success') : logger.debug('fail')
  end

  # Check whether artist data is complete
  def give_to_incomplete?
    give_to_url.nil? || !give_to_verified
  end
end
