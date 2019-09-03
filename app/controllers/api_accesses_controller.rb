class ApiAccessesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :admin_permission
  def verify_api_level
    @api = ApiAccess.find_by_key(params[:key])
  end
  def update
    @api_key = ApiAccess.find(params[:id])
    if @api_key.present?
      @api_key.update(ext_id: params[:api_access][:ext_id], api_accesses_level_id: params[:api_access][:api_accesses_level_id])
      # TODO Adicionar o redirect
    else
      @error = 'Chave inválida'
      # TODO Adicionar o redirect
    end
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      criar_api_access_key(@user, params[:api][:level])
      # TODO Adicionar o redirect
    end
  end
  def create_remote
    @user = User.new(params[:user])
    if @user.save
      criar_api_access_key(@user, params[:api][:level])
      # TODO Adicionar o render
    end
  end
  def criar_api_access_key(user, api_level)
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
end
