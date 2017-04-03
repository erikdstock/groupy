class GiveToApi < BaseApi
  BASE = 'https://www.give.to/api/1.0'.freeze

  def initialize; end

  def check_artist(artist_name, args = {})
    params = { artist_name: artist_name }.merge(args)
    req = RestClient::Request.new(method: :get,
                                  url: "#{BASE}/artists",
                                  payload: params)
    response = handle_response(req.execute)
    if response['artists'].length == 1
      return parse_single_artist(response)
    else
      Rails.logger.debug "artist #{artist_name} not found on give.to api"
      return false
    end
  end

  private

  def parse_single_artist(response)
    artist = response['artists'][0]
    { url: artist['url'],
      image: artist['image'],
      verified: artist['verified'] }
  end

  # Handle the response, checking both the status code and errors property in the json
  def handle_response(response)
    handle_response_errors(response)
    json_response = JSON.parse(response)
    return json_response if json_response['errors'].empty?
    json_response['errors'].each { |e| warn e }
    false
  end

  def handle_response_errors(response)
    status_code = response.code.to_s
    # handle 400-level response
    if status_code =~ /^4/
      warn 'your shits fucked'
    # handle 500-level response
    elsif status_code =~ /^5/
      warn 'givetos fucked'
    end
  end
end
