class UsersController < ApplicationController
  def show
    if current_user
      @user = current_user
    else
      redirect_to root_path
    end
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if user_params[:avatar]
      @user.avatar.attach(user_params[:avatar])
    end
    @user.role_id = 2
    if @user.save
      login(params[:user][:email], params[:user][:password])

      #Criação de chave para realização de operações do usuário no webservice
      options = [('a'..'z'), ('A'..'Z'), ('1' .. '9')].map(&:to_a).flatten # Seleciona letras e números como carácter da chave
      key='a'
      loop do
        key=(0...50).map { options[rand(options.length)] }.join # Cria uma chave de 50 carácteres com letras e números
        api=ApiAccess.find_by(key: key) #Verifica se a chave já existe
        break if !api.present?
      end
      @api=ApiAccess.create(user_id: @user.id, api_accesses_level_id: 2, key: key) # Salva a chave do usuário

      @retorno = session[:login_back_url]
      session[:login_back_url] = user_path
      redirect_to @retorno || user_path
    else
      if @user.password.length < 8
        @user.errors.add(:senha,'A senha deve conter no mínimo 8 caracteres.')
      end
      if @user.password != @user.password_confirmation
        @user.errors.add(:conf_senha,'As senhas digitadas não coincidem.')
      end
      if User.find_by('email = ?', user_params[:email]).present?
        @user.errors.add(:email, 'Já existe usuário com esse e-mail ou CPF.')
      end
      if @user.avatar.blob.content_type != ['image/png', 'image/jpg', 'image/jpeg']
        @user.errors.add(:avatar, 'Não é possível utilizar este formato de imagem, utilize .png ou .jpg ou jpeg')
      end
      render 'new'
    end
  end
  def edit
    @user = current_user
  end
  def edit_pw
    @user = current_user
  end
  def update
    @user = current_user
    if edit_user_params[:avatar]
      @user.avatar.attach(edit_user_params[:avatar])
      @user.skip_password = true
      @user.save
    end
    if params[:user][:edit_type] == 'user'
      @user.skip_password = true
    end
    if @user.update(edit_user_params)
      redirect_to user_path
    else
      if params[:user][:edit_type] == 'user'
        if @user.password.length < 8
          @user.errors.add(:senha,'A senha deve conter no mínimo 8 caracteres.')
        end
        if @user.password != @user.password_confirmation
          @user.errors.add(:conf_senha,'As senhas digitadas não coincidem.')
        end
      end
      if User.find_by('email = ? and id != ?', user_params[:email], @user.id).present?
        @user.errors.add(:email, 'Já existe usuário com esse e-mail.')
      end
      if @user.avatar.blob.content_type != ['image/png', 'image/jpg', 'image/jpeg']
        @user.errors.add(:avatar, 'Não é possível!')
      end
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :cpf, :birth_date, :cep, :state, :city, :address, :phone, :avatar)
  end
  def edit_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :cpf, :birth_date, :cep, :state, :city, :address, :phone, :avatar)
  end
end