class ApplicationController < ActionController::Base
  def admin_permission
    unless current_user and current_user.role.id == 1
      redirect_to user_path
    end
  end
  def logged
    if current_user
      @user = current_user
    else
      redirect_to login_path
    end
  end
  def info_completed
    if current_user
      @user = current_user
      unless current_user.complete?
        redirect_to complete_user_info_path
      end
    else
      redirect_to login_path
    end
  end
  def redirect_to_return
    @retorno = session[:login_back_url]
    session[:login_back_url] = user_path
    redirect_to @retorno || user_path
  end
end
