module AuthenticateOauth
  extend ActiveSupport::Concern

  def process_oauth
    if !@auth.present?
      flash[:error] = "Not able to authenticate user."
      return
    end
    @user = User.find_by(email: @auth[:email])
    unless @user.present?
      @user = User.find_by(email: @auth[:email])
      @user.restore! if @user.present?
    end

    logger.info "Setting up oauth for #{@auth[:fullname]} with #{@auth[:provider]}"
    if @user.present?
      update_user_authentication
      sign_in(:user, @user)
      cookies.permanent.signed[:uid] = @user.id
    else
      create_user_from_auth
    end
  end

  def update_user_authentication
    logger.info "Current user #{@user} is getting their auth updated..."
    current_identity = Identity.find_by(uid: @auth[:uid])
    if !current_identity.present?
      Identity.create( uid: @auth[:uid],
                       provider: @auth[:provider],
                       email: @auth[:email],
                       access_token: @auth[:token],
                       token_expires: @auth[:token_expires],
                       user_id: @user.id )
    else
      current_identity.update( uid: @auth[:uid],
                               provider: @auth[:provider],
                               email: @auth[:email],
                               access_token: @auth[:token],
                               token_expires: @auth[:token_expires],
                               user_id: @user.id )
    end
  end

  def create_user_from_auth
    logger.info "User #{@auth[:email]} does not exist, creating them from Auth attributes..."
    pass = ('a'..'z').to_a.shuffle[0,8].join
    @user = User.new( fullname: @auth[:fullname],
                      email: @auth[:email],
                      password: pass,
                      password_confirmation: pass
    )

    @user.skip_confirmation!
    @user.save!
    
    Identity.create( uid: @auth[:uid],
                     provider: @auth[:provider],
                     email: @auth[:email],
                     access_token: @auth[:token],
                     token_expires: @auth[:token_expires],
                     user_id: @user.id )
    logger.info "New user #{@user} was created!"
    logger.info "Signing in user #{@user}..."
    sign_in(:user, @user)
    cookies.permanent.signed[:uid] = @user.id
  end
  
end