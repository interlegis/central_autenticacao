class ServicesAuthController < ApplicationController
  skip_before_action :require_login, raise: false
  def oauth
    login_at(params[:provider])
  end

  def callback
    if current_user
      @retorno = session[:login_back_url]
      session[:login_back_url] = user_path
      success = vincular_oauth(params[:provider])
      if success
        redirect_to @retorno || user_path, :notice => "Logged in from #{provider.titleize}!"
      else
        redirect_to(user_path, error: 'Não foi possível vincular conta')
      end
    else
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
          authentication = Authentication.find_by(user_id: @user.id)
          authentication.update(email: @user.email)
          auto_login(@user)
          #session[:login_back_url] = @retorno
          #redirect_to adicionar_dados_path, :notice => "Logged in from #{provider.titleize}!"
          redirect_to @retorno || user_path
        else
          #Authentication.create(provider: provider, user_id: existent_user.id, uid: @user.uid)
          # Adicionar mensagem de erro
          render 'sessions/new'
        end
      end
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
      if current_user
        verificao_vincular_cas_interlegis(params[:user][:email], 'interlegis')
      else
        # TODO adicionar verificação se usuário que não logou por oauth, cas ou interlegis já usa esse email
        authentication = Authentication.find_by(provider: 'interlegis', email: params[:user][:email])
        if authentication.present?
          auto_login(authentication.user)
        else
          user = User.new(email: params[:user][:email])
          user.skip_password = true
          if user.save
            vincular_cas_ou_interlegis(user, 'interlegis')
            auto_login(user)
          end
        end
        @retorno = session[:login_back_url]
        session[:login_back_url] = user_path
        redirect_to @retorno || user_path
      end
    else
      redirect_to login_path
    end
  end

  def cas_sign_in
    if session['cas'].present? and session['cas']['user'].present?
      if current_user
        verificao_vincular_cas_interlegis(session['cas']['user']+'@senado.leg.br', 'senado')
      else
        authentication = Authentication.find_by(provider: 'senado', email: session['cas']['user']+'@senado.leg.br')
        if authentication.present?
          auto_login(authentication.user)
        else
          user = User.new(email: session['cas']['user']+'@senado.leg.br')
          user.skip_password = true
          if user.save
            vincular_cas_ou_interlegis(user, 'senado')
            auto_login(user)
          end
        end
        @retorno = session[:login_back_url]
        session[:login_back_url] = user_path
        redirect_to @retorno || user_path
      end
    else
      render status: 401, json: {'authenticate': true}
    end
  end
  private
  def vincular_oauth(provider)
    user = build_from(provider)
    Authentication.new(provider: provider, user_id: current_user.id, uid: user.uid, email: user.email)
    if Authentication.save
      true
    else
      false
    end
  end
  def verificao_vincular_cas_interlegis(email, provider)
    authentication = Authentication.find_by(provider: provider, email: email)
    if authentication.present?
      redirect_to user_path, erro: 'Está conta já está vinculada'
    else
      user = current_user
      user.email = email
      if vincular_cas_ou_interlegis(user, 'senado')
        redirect_to user_path
      else
        redirect_to user_path, erro: 'Erro ao vincular conta'
      end
    end
  end
  def vincular_cas_ou_interlegis(user, provider)
    Authentication.new(provider: provider, user_id: user.id, email: user.email)
    if Authentication.save
      true
    else
      false
    end
  end
end
