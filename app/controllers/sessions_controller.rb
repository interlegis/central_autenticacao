class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path
    else
      @social = params[:social] #indica que o login deve ser feito por redes sociais
      session[:login_back_url] = params[:return] || user_path
    end
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user.present?
      crypted_password = user.crypted_password
      unless user.salt.present? #supõe que está com 2a em vez de 2y e não tem salt
        password=BCrypt::Engine.hash_secret('My@s0202', crypted_password[0,29])
        if password == crypted_password
          user.update(password: params[:user][:password])
          auto_login(user)
          @retorno = session[:login_back_url]
          session[:login_back_url] = user_path
          redirect_to @retorno || user_path
        else
          render 'new'
        end
      else
        if login(params[:user][:email], params[:user][:password])
          @retorno = session[:login_back_url]
          session[:login_back_url] = user_path
          redirect_to @retorno || user_path
        else
          render 'new'
        end
      end

    else
      render 'new'
    end
  end

  def destroy
    if params[:return].present?
      logout
      redirect_to params[:return]
    else
      logout
      redirect_to login_path
    end

  end
end
