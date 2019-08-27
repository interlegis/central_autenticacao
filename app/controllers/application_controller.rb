class ApplicationController < ActionController::Base
  def admin_permission
    unless current_user and current_user.role.id == 1
      redirect_to user_path
    end
  end
end
