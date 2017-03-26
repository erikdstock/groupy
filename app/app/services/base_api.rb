class BaseApi
  def get_recent_tracks(*)
    abstract_method!
  end

  def get_top_artists(*)
    abstract_method!
  end

  private

  def abstract_method!
    raise "not implemented for #{self.class}"
  end
end
