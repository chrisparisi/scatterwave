module ApplicationHelper
  def avatar_url(user)
    if user.image
      "http://graph.facebook.com/#{user.uid}/picture?type=large"
    else
      gravatar_id = Digest::MD5.hexdigest(user.email).downcase
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=retro&s=150"
    end
  end

  def stripe_express_path
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CONNECT_KEY']}&scope=read_write&redirect_uri=#{user_stripe_connect_omniauth_callback_url}"
  end

  def inner_page?
    (user_signed_in?) &&
        !current_page?(root_path) &&
        !current_page?(search_shows_path) &&
        !current_page?(search_bands_path) &&
        !current_page?(search_venues_path)
  end

end
