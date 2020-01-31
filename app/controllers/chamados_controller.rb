class ChamadosController < ApplicationController
  layout :define_layout
  before_filter :load_unidades
  before_filter :load_estagiarios
  before_filter :load_situacaos
  before_filter :load_tipos

   def busca_protocolo
    define_layout
    if (params[:search].present?)
       @chamados = Chamado.find(:all, :conditions => ["id = ?",  params[:search]])
       
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chamados }
    end
  end

  def index
    define_layout
      if (params[:search].nil? || params[:search].empty?)
        @chamados_totais = Chamado.all
        @chamados = Chamado.nao_encerrado
        @chamados_aberto = Chamado.aberto
        @chamados_encerrado = Chamado.encerrado
        @chamados_terceiros = Chamado.terceiro
        @chamados_motoristas = Chamado.motorista
        @chamados_compras = Chamado.compras
        @chamados_atendimento = Chamado.atendimento
        @chamados_externo = Chamado.externo
        $var = 0
      else
        @chamados = Chamado.find(:all, :joins => :unidade, :conditions => ["unidades.nome like ?", "%" + params[:search].to_s + "%"], :order => 'situacao_chamado_id,nome DESC')
        $var = 1
      end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chamados }
    end
  end

def novo

end

  def show
   define_layout
    @chamados = Chamado.find(params[:id])
    session[:id_chamado]=params[:id]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chamados }
    end
  end

  def new
   define_layout
    @chamados = Chamado.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chamados }
    end
  end

  def edit
    define_layout
    @chamados = Chamado.find(params[:id])
  end

  def create
    define_layout
    @chamados = Chamado.new(params[:chamado])
    respond_to do |format|
      if @chamados.save
        flash[:notice] = 'SOLICITAÇÃO DE SERVIÇO CADASTRADA COM SUCESSO.'
        #ChamadoMailer.deliver_notificar(@chamados)
        format.html { redirect_to(@chamados) }
        format.xml  { render :xml => @chamados, :status => :created, :location => @chamados }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chamados.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    define_layout
    @chamados = Chamado.find(params[:id])
    w= session[:id_chamado_encerrado]= params[:id]
    t=0
    respond_to do |format|
      if @chamados.update_attributes(params[:chamado])
        flash[:notice] = 'SOLICITAÇÃO DE SERVIÇO SALVA COM SUCESSO.'
        #format.html { redirect_to(chamados_path) }
        #format.html { redirect_to(chamado_encerrado_path) }
        format.html { redirect_to( {:action => "showencerrado", :id => session[:id_chamado_encerrado]}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chamados.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    define_layout
    @chamados = Chamado.find(params[:id])
    @chamados.destroy
    respond_to do |format|
      format.html { redirect_to(chamados_url) }
      format.xml  { head :ok }
    end
  end

  def ordemservico

    define_layout
    @chamados = Chamado.find_by_sql("SELECT uni.nome as nome, cha.id, cha.data_sol,  cha.solicitante, cha.unidade_id, cha.forma_sol, cha.problema, cha.data_aten, cha.estagiario_id, cha.tipos_problema_id, cha.patrimonio, cha.local, cha.procedimentos, cha.situacao_chamado_id, cha.data_enc, cha.obs, cha.email FROM chamados cha LEFT JOIN "+session[:base]+".unidades uni ON uni.id = cha.unidade_id WHERE cha.id ="+ params[:id] +" order by nome ASC")
  end

 def showencerrado
   define_layout
     @chamados = Chamado.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @chamados }
    end
 end

 def selected_print
      session[:chamados]= params[:chamado_ids]
      @chamados = Chamado.find(params[:chamado_ids], :joins => "LEFT JOIN "+session[:base]+".unidades uni ON uni.id = chamados.unidade_id")
 end

 def impressao_atendimento
        @chamados = Chamado.find(session[:chamados], :joins => "LEFT JOIN "+session[:base]+".unidades uni ON uni.id = chamados.unidade_id")
        render :layout => "impressao"
 end

  def define_layout
    if logged_in?
      'application'
    else
      'application_chamados'
    end
  end

   def encerrados
    @chamados_encerrado = Chamado.encerrado
    if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao')
        @chamados = Chamado.find_by_sql("SELECT est.nome as estagiario, uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_chamado_id, mma.estagiario_id, mma.problema, mma.data_sol, mma.data_aten, mma.data_enc, mma.solicitante, mma.procedimentos,  mma.obs  FROM chamados mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id   INNER JOIN  estagiarios est ON mma.estagiario_id = est.id WHERE situacao_chamado_id = 12  order by data_enc DESC")
    else
       @chamados = Chamado.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_chamado_id, mma.estagiario_id, mma.problema, mma.data_sol, mma.data_aten, mma.data_enc,  mma.solicitante, mma.procedimentos,  mma.obs  FROM chamados mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_chamado_id = 12 and unidade_id ="+(current_user.unidade_id).to_s+" order by data_enc DESC ")
    end

  end

 protected
  def load_tipos
    @tipos = TiposProblema.find(:all)
  end

  def load_situacaos
    @situacaos = SituacaoChamado.find(:all)
  end

  def load_estagiarios
    @estagiarios = Estagiario.find(:all, :order => 'nome ASC',:conditions => ['desligado=?',0])
    @funcionarios = Estagiario.find(:all, :order => 'nome ASC',:conditions => ['desligado=?  and unidade_id=? and id<>? and id<>?',0,53,2,47])
  end

  def load_unidades
    @unidades = Unidade.find(:all, :order => 'nome ASC')
      if current_user.unidade_id == 52 or current_user.unidade_id == 53
           @protocolos = Chamado.find(:all, :conditions =>['situacao_chamado_id != 12'], :order => 'id ASC')
      else
          @protocolos = Chamado.find(:all, :conditions =>['unidade_id =? AND situacao_chamado_id != 12', current_user.unidade_id], :order => 'id ASC')
      end
  end

end