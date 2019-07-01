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
    @user.role = 'usuario'
    if @user.save
      login(params[:user][:email], params[:user][:password])
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
      render 'new'
    end

  end
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :cpf, :birth_date, :cep, :state, :city, :address)
  end
end