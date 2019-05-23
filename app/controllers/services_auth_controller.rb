class ServicesAuthController < ApplicationController
  skip_before_action :require_login, raise: false
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    @retorno = session[:login_back_url]
    session[:login_back_url] = user_path
    if @user = login_from(provider)
      redirect_to @retorno || user_path, :notice => "Logged in from #{provider.titleize}!"
    else
      @user = build_from(provider)
      existent_user = User.find_by(email: @user.email)
      if !existent_user.present?
        @user = create_from(provider)

      else
        Authentication.create(provider: provider, user_id: existent_user.id, uid: @user.uid)
        @user = existent_user
      end
      auto_login(@user)
      #session[:login_back_url] = @retorno
      #redirect_to adicionar_dados_path, :notice => "Logged in from #{provider.titleize}!"
      redirect_to @retorno || user_path
    end
  end

  def interlegis_sign_in_page
    if current_user
      redirect_to user_path
    end
  end

  def interlegis_sign_in
    require 'net/imap'
    logged = false
    begin
      imap = Net::IMAP.new("mailproxy.interlegis.leg.br", 993, true)
      imap.login(params[:user][:email], params[:user][:password])
      logged = true
    rescue
      logged = false
    end
    if (logged)
      user = User.find_by_email(params[:user][:email]+'@interlegis.leg.br')
      if user.present?
        auto_login(user)
      else
        user = User.new(email: params[:user][:email])
        user.skip_password = true
        if user.save
          auto_login(user)
        end
      end
      @retorno = session[:login_back_url]
      session[:login_back_url] = user_path
      redirect_to @retorno || user_path
    else
      redirect_to root_path
    end
  end

  def cas_sign_in
    if session['cas'].present? and session['cas']['user'].present?
      user = User.find_by_email(session['cas']['user']+'@senado.leg.br')
      if user.present?
        auto_login(user)
      else
        user = User.new(email: session['cas']['user']+'@senado.leg.br')
        user.skip_password = true
        if user.save
          auto_login(user)
        end
      end
      @retorno = session[:login_back_url]
      session[:login_back_url] = user_path
      redirect_to @retorno || user_path
    else
      render status: 401, json: {'authenticate': true}
    end
  end
end
