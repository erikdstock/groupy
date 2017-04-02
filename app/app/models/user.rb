class User < ApplicationRecord
  # Include devise modules. Others available are:
  #  :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, omniauth_providers: [:lastfm]
  has_many :monthly_top_artists

  has_many :top_artists, through: :monthly_top_artists, source: :artist
  after_create :queue_initial_refresh

  include ListeningStats
  include TimeTools

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      # user.email     = auth.info.email # not in lastfm hash
      user.name      = auth.info.name
      user.image     = auth.info.image
    end
  end

  # Get top artists for month
  # @param {Time}
  def top_artists_for_month(time)
    time_range = time_range_month(time)
    current_artists = top_artists_for_time(time_range)
    current_artists
  end

  # Update existing monthly_top_artists with new data
  # TODO: this method needs testing.
  # @param new_artists [Hash] of values to update/create artists
  # @param month [Time] time-like object with month
  # @return {ActiveRecord Relation} of updated artists or false
  def update_top_artists_for_month(new_artists, month)
    top_artists_for_month(month).delete_all
    new_collection = new_artists.map do |name, new_artist_data|
      artist = Artist.find_or_create_by(name: name)
      artist.image = new_artist_data[:image]
      artist.save
      MonthlyTopArtist.new(user: self,
                           artist: artist,
                           month: month,
                           play_count: new_artist_data[:play_count])
    end
    save_collection(new_collection)
  end

  # On create, get top artists for current month and previous month.
  def queue_initial_refresh
    LastfmUpdateMonthlyTopArtistsWorker.perform_async(id, 0.months.ago)
    LastfmUpdateMonthlyTopArtistsWorker.perform_async(id, 1.month.ago)
  end

  private

  def top_artists_for_time(time_range)
    MonthlyTopArtist.where(user_id: id, month: time_range).includes(:artist)
  end

  # TODO: Remove?
  def top_artist_attributes
    [
      'artists.name',
      'artists.image',
      'month',
      'play_count',
      'user_id',
      'artist_id',
      'monthly_top_artists.updated_at'
    ].join(', ')
  end

  def save_collection(collection)
    success = collection.map(&:save)
    unless success.all?
      errored = new_collection.reject { |m| m.errors.blank? }
      errored.each { |m| logger.warn m.errors }
      return false
    end
    true
  end
end
