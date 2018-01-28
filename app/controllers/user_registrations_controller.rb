class UserRegistrationsController < Devise::RegistrationsController

  #https://github.com/plataformatec/devise/wiki/How-To:-Customize-the-redirect-after-a-user-edits-their-profile  

  protected

  def after_update_path_for(resource)
    welcome_path(resource)
  end

end
