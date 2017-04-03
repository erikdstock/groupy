module OauthHelpers
  def stub_omniauth(opts = {})
    default = {
      provider: :lastfm,
      uuid: 'erikdstock',
      info: {
        name: 'erikdstock',
        image: 'http://img2-ak.lst.fm/i/u/300x300/d471f884db13e2357c915c7547c59edf.png'
      }
    }

    credentials = default.deep_merge(opts)
    provider = credentials[:provider]

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(credentials)
  end

  # def set_invalid_omniauth(opts = {})
  #
  #   credentials = { :provider => :facebook,
  #                   :invalid  => :invalid_crendentials
  #                  }.merge(opts)
  #
  #   OmniAuth.config.test_mode = true
  #   OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
  #
  # end
end
