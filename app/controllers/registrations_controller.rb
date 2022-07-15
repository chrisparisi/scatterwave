class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :authenticate_scope!, only: [:edit,:change_password, :changed_password]

  def changed_password
    self.resource = current_user
    if resource.update_with_password(account_update_params)
      bypass_sign_in(resource)
      flash[:notice] = "Your Password Change successfully."
      redirect_to change_password_path
    else
      render 'change_password'
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
