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
    if login(params[:user][:email], params[:user][:password])
      @retorno = session[:login_back_url]
      session[:login_back_url] = user_path
      redirect_to @retorno
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
