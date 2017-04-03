module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Concerns::OauthHelpers

    def lastfm_old
      @user = User.from_omniauth(auth_hash)
      if @user.persisted?
        sign_in_and_redirect(@user) # , event: :authentication #used for Warden Callbacks w/ devise
        set_flash_message(:notice, :success, kind: 'lastfm') if is_navigational_format?
      else
        session['devise.lastfm_data'] = auth_hash
        redirect_to :root
        if is_navigational_format?
          set_flash_message(:notice, :failure,
                            kind: 'lastfm',
                            reason: @user.errors.full_messages)
        end
      end
    end

    def lastfm
      omni = request.env['omniauth.auth']
      p omni
      authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
      if authentication
        p 'Wubba'
        sign_in_user(authentication)
      elsif current_user
        p 'Lubba'
        add_new_oauth(authentication, omni)
      else
        p 'Dub Dub'
        create_new_user(omni)
      end
    end


    def spotify
      omni = request.env['omniauth.auth']
      authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
      if authentication
        sign_in_user(authentication)
      elsif current_user
        add_new_oauth(authentication, omni)
      else
        create_new_user(omni)
      end
    end
  end
end
