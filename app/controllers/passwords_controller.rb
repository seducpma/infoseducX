class PasswordsController < ApplicationController
  before_filter :login_required
  skip_before_filter :login_required, :only => [:atualiza,:new, :create,:edit,:update]
  layout 'login'
  def new
  end

  def create
  return unless request.post?
  if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      ChamadoMailer.deliver_forgot_password(@user)
      @user.save
      flash[:notice] = "Um de link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
    redirect_to login_path
    else
      flash[:notice] = "Nenhum usuário cadastrado com o e-mail indicado."
      render :action => 'new'
    end
  end

  def edit

    if params[:id].nil?
      render :action => 'new'
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Codigo de substituição de senha incompatível."
    flash[:notice] = "Desculpe - Este é um código de substituição de senha invalido. Favor confirir e tentar novamente."
    #redirect_back_or_default('/')
    redirect_to new_user_path
  end


  def atualiza
    if params[:id].nil?
      render :action => 'new'
      return
    end
    if params[:password].blank?
      flash[:notice] = "O campo Senha não pode estar em branco."
      render :action => 'edit', :id => params[:id]
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
    return if @user unless params[:password]
      if (params[:password] == params[:password_confirmation])
        @user.password_confirmation = params[:password_confirmation]
        @user.password = params[:password]
        @user.reset_password
        flash[:notice] = @user.save ? "Senha alterada." : "Password not reset."
      else
        flash[:notice2] = "ERRO: As senhas estão diferentes repita o processo."
        render :action => 'edit', :id => params[:id]
        return
      end
      redirect_to login_path
  rescue
    logger.error "Codigo de substituição de senha incompatível."
    flash[:notice] = "Desculpe - Este é um código de substituição de senha invalido. Favor confirir e tentar novamente."
    redirect_to new_user_path

  end
  def update

  end

end