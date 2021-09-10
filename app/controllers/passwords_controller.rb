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
      flash[:notice] = "Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
    redirect_to login_path
    else
      flash[:notice] = "Nenhum usuário cadastrado com o e-mail informado."
      render :action => 'new'
    end
  end

  def tela_email
     
  end

  def tela_email_chamado

  end


    def tela_email_chamado_enc

  end


  def tela_email_devolucao
   @mmanutencao = Mmanutencao.find(session[:id_manutencao])
   ww= session[:email]
  session[:idprotocolo]= @mmanutencao.id
  end


  def tela_email_devolucao_compra
   @mmanutencao = Mmanutencao.find(session[:id_manutencao])
   ww= session[:email]
  session[:idprotocolo]= @mmanutencao.id
  end





   def email_devolucao
t=0
  #   participante = Participante.find_by_matricula(params[:matricula])
       wwa=email=session[:email]
t=0
      if !session[:id_manutencao].nil?
       @mmanutencao= Mmanutencao.find(session[:id_manutencao])
       @mmanutencao.data3= Time.now
       @mmanutencao.save
       t=0
      end
       #InscricaoMailer.deliver_confirmacao_inscricao(@inscricao,@inscricao.participante)
       t=0
       MmanutencaoMailer.deliver_devolucao_email(@mmanutencao,email)
  end


   def email_devolucao_compra
t=0
  #   participante = Participante.find_by_matricula(params[:matricula])
       wwa=email=session[:email]
t=0
      if !session[:id_manutencao].nil?
       @mmanutencao= Mmanutencao.find(session[:id_manutencao])
       @mmanutencao.data3= Time.now
       @mmanutencao.save
       t=0
      end
       #InscricaoMailer.deliver_confirmacao_inscricao(@inscricao,@inscricao.participante)
       t=0
       MmanutencaoMailer.deliver_devolucao_email(@mmanutencao,email)
  end


  def email
       
  #   participante = Participante.find_by_matricula(params[:matricula])
       session[:email]=email= (params[:email])
t=0
      if !session[:id_manutencao].nil?
       @mmanutencao= Mmanutencao.find(session[:id_manutencao])
       @mmanutencao.data3= Time.now
       @mmanutencao.save
       t=0
      end
       #InscricaoMailer.deliver_confirmacao_inscricao(@inscricao,@inscricao.participante)
       MmanutencaoMailer.deliver_enviar_email(@mmanutencao,email)
  end
  #return unless request.post?
  #if @user = User.find_for_forget(params[:email])
  #    @user.forgot_password
  #    ChamadoMailer.deliver_forgot_password(@user)
  #    @user.save
  #    flash[:notice] = "Um link para efetuar a troca da senha foi enviado para o e-mail cadastrado."
  #  redirect_to login_path
  #  else
  #    flash[:notice] = "Nenhum usuário cadastrado com o e-mail informado."
  #    render :action => 'new'
  #  end
  #end

  def email_chamado
       w=session[:email]=email= (params[:email])
      if !session[:id_chamado].nil?
       @chamado= Chamado.find(session[:id_chamado])
     #  @mmanutencao.data3= Time.now
     #  @mmanutencao.save
      end
       #InscricaoMailer.deliver_confirmacao_inscricao(@inscricao,@inscricao.participante)
      # MmanutencaoMailer.deliver_enviar_email(@mmanutencao,email)
       Chamado1Mailer.deliver_enviar_email(@chamado,email)
  end

  def email_chamado_enc
       w=session[:email]=email= (params[:email])
      if !session[:id_chamado].nil?
       @chamado= Chamado.find(session[:id_chamado])
     #  @mmanutencao.data3= Time.now
     #  @mmanutencao.save
      end
       #InscricaoMailer.deliver_confirmacao_inscricao(@inscricao,@inscricao.participante)
      # MmanutencaoMailer.deliver_enviar_email(@mmanutencao,email)
       Chamado2Mailer.deliver_enviar_email(@chamado,email)
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
    flash[:notice] = "ERRO: Algo deu errado, por favor tente novamente ou procure a Informática da SEDUC."
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
        flash[:notice] = @user.save ? "A senha foi alterada com sucesso!" : "ERRO: A senha não foi alterada."
      else
        flash[:notice2] = "ERRO: As senhas estão diferentes repita o processo."
        render :action => 'edit', :id => params[:id]
        return
      end
      redirect_to login_path
    rescue
        logger.error "Codigo de substituição de senha incompatível."
        flash[:notice] = "ERRO: Algo deu errado, por favor tente novamente ou procure a Informática da SEDUC."
        redirect_to new_user_path

  end

  def update
  end
end