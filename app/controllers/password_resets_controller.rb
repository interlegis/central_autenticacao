class PasswordResetsController < ApplicationController
  # In Rails 5 and above, this will raise an error if
  # before_action :require_login
  # is not declared in your ApplicationController.
  skip_before_action :require_login, raise: false
  
  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create 
    @user = User.find_by_email(params[:email])
    if @user     
      @user.deliver_reset_password_instructions!
      if @user.reset_password_token
        puts(@user.reset_password_token)
        puts("AQUI")
        UserMailer.reset_password_email(@user).deliver_now    
        redirect_to(root_path, :notice => 'Verifique o seu email para resetar a sua senha.')
      else 
        puts("Não é possível")
        redirect_to(root_path, :notice=> 'Tente mais tarde, a senha foi alterada recentemente')
      end
    else
      redirect_to(root_path, :notice=> 'Não existe esse email no sistema.')
    end 
  end
    
  # This is the reset password form.
  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end
      
  # This action fires when the user has sent the reset password form.
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:senha, "As senhas não são iguais")
      return render :action => "edit"
    end

    if params[:user][:password].length < 8
      @user.errors.add(:senha, "'A senha deve conter no mínimo 8 caracteres.'")
      return render :action => "edit"
    end

    if @user.blank?
      not_authenticated
      return
    end
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password!(params[:user][:password])
      redirect_to(root_path, :notice => 'Senha atualizada com sucesso!')
    else
      render :action => "edit"
    end
  end
end