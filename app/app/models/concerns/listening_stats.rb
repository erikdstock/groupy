module ListeningStats
  def fetch_top_artists_by_period(args = {})
    from = args.fetch(:from)
    to = args.fetch(:to)
    service.top_artists_by_period(self, from: from, to: to)
  end

  # Deprecate - use #fetch_api_top_artists
  def api_top_artists(args = {})
    response = service.get_top_artists(self, args)
    result = response['topartists']['artist']
    # Sort artists by tipped, accepting and invitable
    result
  end

  private

  def service(service_class = LastfmApi)
    @service ||= service_class.new
  end
end
