class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include AuthenticateOauth

  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env['omniauth.auth'])
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
  #     set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  #   else
  #     session['devise.facebook_data'] = request.env['omniauth.auth']
  #     redirect_to new_user_registration_url
  #   end
  # end

  def facebook
    logger.info request.env["omniauth.auth"]
    @auth = {
        provider: request.env["omniauth.auth"].provider,
        uid: request.env["omniauth.auth"].uid,
        email: request.env["omniauth.auth"].info.email,
        token: request.env["omniauth.auth"].credentials.token,
        token_expires: request.env["omniauth.auth"].credentials.expired_at,
        fullname: request.env["omniauth.auth"].info.name,
        profile_image: request.env["omniauth.auth"].info.image,
    }

    if current_user && current_user.present?
      session[:token]=@auth[:token]
      redirect_to root_path
    else
      process_oauth
      redirect_to root_path
    end
  end


  def google_oauth2
    @auth = {
        provider: request.env["omniauth.auth"].provider,
        uid: request.env["omniauth.auth"].uid,
        email: request.env["omniauth.auth"].info.email,
        token: request.env["omniauth.auth"].credentials.token,
        token_expires: request.env["omniauth.auth"].credentials.expired_at,
        fullname: request.env["omniauth.auth"].info.name,
        profile_image: request.env["omniauth.auth"].info.picture_url
    }

    if current_user && current_user.present?
      session[:token]=@auth[:token]
      redirect_to root_path
    else
      process_oauth
      redirect_to root_path
    end
  end

  def stripe_connect
    auth_data = request.env['omniauth.auth']
    @user = current_user

    if @user.persisted?
      @user.merchant_id = auth_data.uid
      @user.save

      if @user.merchant_id.present?
        # Update Payout Schedule
        account = Stripe::Account.retrieve(current_user.merchant_id)
        account.payout_schedule.delay_days = 7
        account.payout_schedule.interval = 'daily'

        # account.payout_schedule.monthly_anchor = 15
        # account.payout_schedule.interval = "monthly"
        account.save
        if current_user.venues.present?
          current_user.venues.each do |v|
            v.update(active: true) if !v.active && v.payout.present? && v.listing_name.present? && v.photos.present? && v.address.present?
          end
        end
        if current_user.band.present?
          current_user.band.update(active: true) if !current_user.band.active && current_user.band.summary.present? && current_user.band.pictures.present? && current_user.band.address.present?
        end
        logger.debug account.to_s
      end

      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'Stripe account created and connected' if is_navigational_format?

    else
      session['devise.stripe_connect_data'] = request.env['omniauth.auth']
      redirect_to dashboard_path
    end
  end

  def failure
    redirect_to root_path
  end
end
