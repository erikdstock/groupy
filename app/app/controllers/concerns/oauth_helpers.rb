module Concerns
  module OauthHelpers
    extend ActiveSupport::Concern

    def sign_in_user(authentication)
      sign_in_and_redirect User.find(authentication.user_id)
    end

    def add_new_oauth(authentication, omni)
      token = omni['credentials'].token
      token_secret = omni['credentials'].secret
      current_user.authentications.create!(provider: omni['provider'], uid: omni['uid'], 
                                          token: token, token_secret: token_secret)
      sign_in_and_redirect current_user
    end

    def create_new_user(omni)
      p "creating new user"
      user = User.new
      user.apply_omniauth(omni)
      user.email = omni['extra']['raw_info'].email
      if user.save 
        sign_in_and_redirect user
      else
        p user.errors.full_messages
        redirect_to new_user_registration_path
      end
    end

    def after_sign_in_path_for(user)
      user_dashboard_path
    end

  end
end