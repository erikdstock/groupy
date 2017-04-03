class User < ApplicationRecord
  include ListeningStats
  include TimeTools
  has_many :authentications
  has_many :monthly_top_artists
  has_many :top_artists, through: :monthly_top_artists, source: :artist

  devise(
    # :confirmable,            # sends emails with confirmation instructions and verifies whether an account is already confirmed 
    :database_authenticatable, # hashes and stores a password in the database to validate the authenticity of a user while signing in. 
    # :lockable,               # lock account after failed signin attempts
    :omniauthable,             # omniauth.
    :recoverable,              # Password reset
    :registerable,             # handles signing up users through a registration process, also allowing them to edit and destroy their account.
    :rememberable,             # manages generating and clearing a token for remembering the user from a saved cookie.
    # :timeoutable,            # expires sessions that have not been active in a specified period of time.
    :trackable,                # tracks sign in count, timestamps and IP address.
    :validatable,              # provides validations of email and password.
    omniauth_providers: [:lastfm]
  )
  after_create :queue_initial_refresh


  def apply_omniauth(omni)
    authentications.build(
      provider: omni['provider'],
      uid: omni['uid'],
      token: omni['credentials'].token,
      token_secret: omni['credentials'].secret
    )
  end

  def password_required?
    authentications.empty? && super
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
