module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def lastfm
      @user = User.from_omniauth(auth_hash)
      if @user.persisted?
        sign_in_and_redirect(@user) # , event: :authentication #used for Warden Callbacks w/ devise
        set_flash_message(:notice, :success, kind: 'lastfm') if is_navigational_format?
      else
        session['devise.lastfm_data'] = auth_hash
        redirect_to :root
        set_flash_message(:notice, :failure,
                          kind: 'lastfm',
                          reason: @user.errors.full_messages) if is_navigational_format?
      end
    end
  end
end
