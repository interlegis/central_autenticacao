class SessionsController < ApplicationController
  def new
    callback_url = user_path
    if params[:return].present?
      callback_url = params[:return]
      unless callback_url.include? 'http'
        callback_url = 'https://' + callback_url
      end
      callback = URI.parse(callback_url)
      unless callback.host.include? 'interlegis.leg.br'
        callback_url = user_path
      end
    end
    if current_user
      redirect_to callback_url || user_path
    else
      @social = params[:social] #indica que o login deve ser feito por redes sociais
      session[:login_back_url] = callback_url || user_path
      @erro = false
    end
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user.present?
      crypted_password = user.crypted_password
      if !user.salt.present? and user.crypted_password.present? #supõe que está com 2a em vez de 2y e não tem salt
        print(params[:user][:password])
        print(params[:user][:email])
        password=BCrypt::Engine.hash_secret(params[:user][:password], crypted_password[0,29])
        if password == crypted_password
          user.update(password: params[:user][:password])
          auto_login(user)
          @retorno = session[:login_back_url]
          session[:login_back_url] = user_path
          redirect_to @retorno || user_path
        else
          @erro = true
          render 'new'
        end
      else
        if login(params[:user][:email], params[:user][:password])
          @retorno = session[:login_back_url]
          session[:login_back_url] = user_path
          redirect_to @retorno || user_path
        else
          @erro = true
          render 'new'
        end
      end

    else
      @erro = true
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
