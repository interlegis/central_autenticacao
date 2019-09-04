class ApiAccessesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :admin_permission, except: [:create_remote]
  before_action :admin_api_key, only: [:create_remote]
  def verify_api_level
    @api = ApiAccess.find_by_key(params[:key])
  end
  def update
    @api_key = ApiAccess.find(params[:id])
    if @api_key.present?
      @api_key.update(ext_id: params[:api_access][:ext_id], api_accesses_level_id: params[:api_access][:api_accesses_level_id])
      redirect_to panel_keys_path
    else
      @error = 'Chave inválida'
      @api_keys = ApiAccess.all
      render 'users/panel'
    end
  end
  def new
    @user = User.new
  end
  def create
    if create_user_with_api
      redirect_to panel_keys_path
    else
      @error = 'Não foi possível criar esse usuário'
      @api_keys = ApiAccess.all
      render 'users/panel'
    end
  end
  def create_remote
    @success = create_user_with_api
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def criar_api_access_key(user, api_level, ext_id)
    #Criação de chave para realização de operações do usuário no webservice
    options = [('a'..'z'), ('A'..'Z'), ('1' .. '9')].map(&:to_a).flatten # Seleciona letras e números como carácter da chave
    key='a'
    loop do
      key=(0...50).map { options[rand(options.length)] }.join # Cria uma chave de 50 carácteres com letras e números
      api=ApiAccess.find_by(key: key) #Verifica se a chave já existe
      break if !api.present?
    end
    @api=ApiAccess.create(user_id: user.id, api_accesses_level_id: api_level, key: key) # Salva a chave do usuário
  end

  def create_user_with_api
    options_cpf = [('1' .. '9')].map(&:to_a).flatten
    cpf=''
    loop do
      cpf=(0...11).map { options_cpf[rand(options_cpf.length)] }.join # Cria um cpf aleatório TODO pensar em solução melhor
      cpf.insert(3,'.')
      cpf.insert(7,'.')
      cpf.insert(11,'-')
      user=User.find_by(cpf: cpf)
      break unless user.present?
    end
    @user = User.new(user_params)
    @user.cpf = cpf
    @user.role_id = 2
    @user.skip_password = true
    @user.skip_avatar = true
    if @user.save
      criar_api_access_key(@user, params[:user][:api_accesses_level_id], params[:user][:ext_id])
      true
    else
      false
    end
  end
  def admin_api_key
    api_key = ApiAccess.find_by_key(params[:key])
    unless api_key.present? and api_key.api_accesses_level.id > 3
      render status: 400, json: {
          message: "Chave inválida ou ausente",
      }.to_json
    end
  end
end
