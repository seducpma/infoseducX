class ParticipantesController < ApplicationController

  # Tipo participante
  # 1 - Pertence à SEDUC-Americana
  # 2 - NÃO Pertence à SEDUC-Americana


 before_filter :load_participantes
  layout :logado?

  before_filter :load_unidades

  def addemail
    @participante = Participante.find(params[:id])
  end

  def update_email
    @participante = Participante.find(params[:id])
    respond_to do |format|
      @participante.email = params[:email]
      @participante.fone = params[:telefone]
      @participante.cel = params[:cel]
      if @participante.save
        flash[:notice] = 'EMAIL DO PARTICIPANTE ATUALIZADO COM SUCESSO.'
        format.html { redirect_to(new_inscricao_path(:participante => @participante)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "addemail" }
        format.xml  { render :xml => @participante.errors, :status => :unprocessable_entity }
      end
    end
  end

  def busca_por_turno
      @turno_op = Inscricao.paginate(:all, :conditions => ["periodoop1 = ? or periodoop2 =?", params[:turno], params[:turno]],:per_page =>10,:page => params[:page], :order => 'periodoop1 ASC')
  end

  def logado?
    if logged_in?
      "application"
    else
      "inscricao"
    end
  end

  def ger_index
    @participantes = Participante.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participantes }
    end
  end


def index
    if (params[:search].nil? || params[:search].empty?)
       @participantes = Participante.find(:all)
    else
       @participantes = Participante.find(:all, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"], :order => 'nome ASC')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participantes }
    end
  end

  def show
     @participante = Participante.find(params[:id])
     if @participante.professor_id.present?
         @professor = Professor.find(@participante.professor_id)
     end
     if @participante.funcionario_id.present?
         @funcionario = Funcionario.find(@participante.funcionario_id)
     end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participante }
    end
  end

  def new
    $parti=0
    @participante = Participante.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participante }
    end
  end

  def edit
    $parti=1
    @participante = Participante.find(params[:id])
  end

  def create
    @participante = Participante.new(params[:participante])
    @participante.desligado = 0
    existe= 0
                if !@participante.funcionario_id.nil?
                   @participanteExisteF = Participante.find(:all, :select =>'id', :conditions=> ['funcionario_id =? AND  desligado != 1',@participante.funcionario_id])
                    if @participanteExisteF.present?
                       existe =  @participanteExisteF[0].id
                    end
                    @funcionario=Funcionario.find(@participante.funcionario_id)
                    @participante.nome = @funcionario.nome
                    @participante.matricula = @funcionario.matricula
                    @participante.unidade_id = @funcionario.unidade_id
                    @participante.funcao = @funcionario.funcao
                    @participante.telefone = @funcionario.fone
                    @participante.cel = @funcionario.cel
                else  if !@participante.professor_id.nil?
                        @participanteExisteP = Participante.find(:all, :select =>'id', :conditions=> ['professor_id =? AND  desligado != 1',@participante.professor_id])
                        if @participanteExisteP.present?
                            existe = @participanteExisteP[0].id
                        end
                        @professor=Professor.find(@participante.professor_id)
                        @participante.nome = @professor.nome
                        @participante.matricula = @professor.matricula
                        @participante.unidade_id = @professor.unidade_id
                        @participante.funcao = @professor.funcao
                        @participante.funcao = @professor.funcao
                        @participante.telefone = @professor.telefone
                        @participante.cel = @professor.cel
                        else  if @participante.professor_id.nil? and @participante.funcionario_id.nil?
                                    @participanteExiste = Participante.find(:all, :select =>'id', :conditions=> ['professor_id is null and  professor_id is  null and desligado != 1 and nome =?',@participante.nome ])
                                        if @participanteExiste.present?
                                            existe = @participanteExiste[0].id
                                        end
                              end  
                        end
                end
      if  existe != 0
          respond_to do |format|
               format.html { redirect_to(aviso_participantes_path) }
                format.xml  { head :ok }
          end
      else
              respond_to do |format|
                  if @participante.save
                       flash[:notice] = 'SALVO COM SUCESSO.'
                                format.html { redirect_to(@participante) }
                                format.xml  { render :xml => @participante, :status => :created, :location => @participante }
                  else
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @participante.errors, :status => :unprocessable_entity }
                  end
                end
        end
  end

  def update
    @participante = Participante.find(params[:id])
    respond_to do |format|
      if @participante.update_attributes(params[:participante])
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@participante) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participante.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @participante = Participante.find(params[:id])
    @participante.destroy
    respond_to do |format|
      format.html { redirect_to(participantes_url) }
      format.xml  { head :ok }
    end
  end

  def consulta

  end


  def lista_participante
    @inscricao = Inscricao.find_by_participante_id(params[:participante_participante_id])
    render :partial => 'lista_participantes'
  end

  def lista_participante1
    t=0
    w=params[:participante_participante_id]
    #@inscricao = Inscricao.find_by_participante_id(params[:participante_participante_id])
    @participante= Participante.find(:all,  :conditions=> ['id =?',params[:participante_participante_id] ])
    render :partial => 'lista_participantes'
  #   render :update do |page|
  #               page.replace_html 'listagem', :partial => 'lista_participantes'
  #  end

  end

 def lista_inscricaos
     @inscricaos = Inscricao.find(:all, :joins => :participante, :conditions => ["participantes.nome like ?", "%" + params[:search1].to_s + "%"],:order => 'inscricaos.data_inscricao DESC')
                     render :update do |page|
                          page.replace_html 'listagem', :partial => "lista_inscricao"
                     end
 end

  def lista_participante_index
    @participantes = Participante.find(:all, :conditions => ["id = ?",params[:participante_participante_id] ])
       format.html { render :action => "index" }
  end

  def mesmo_nome
    @verifica = Participante.find_by_nome(params[:participante_nome])
    if @verifica then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => 'NOME JÁ CONSTA NO SISTEMA'
        page.replace_html 'Certeza', :text => "PARTICIPANTE JÁ CADASTRADO "
      end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
      end
    end
  end

def professor_dados
    @dadosProf = Professor.find(:all, :conditions => ["professors.id= ?", params[:participante_professor_id]], :joins => "LEFT JOIN "+session[:base]+".unidades uni ON uni.id = professors.unidade_id")
    render :partial => 'dadosProf'
  end

def funcionario_dados
    @dadosFunc = Funcionario.find(:all, :conditions => ["funcionarios.id= ?", params[:participante_funcionario_id]], :joins => "LEFT JOIN "+session[:base]+".unidades uni ON uni.id = funcionarios.unidade_id")
    render :partial => 'dadosFunc'
  end

  protected
  def load_unidades
    @participantes = Participante.find(:all,:order => 'nome ASC')
    @professors = Professor.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
    @funcionarios = Funcionario.find(:all, :conditions => 'desligado = 0',:order => 'nome ASC')
    @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

  def load_participantes
    @participantes = Participante.find(:all, :order => 'nome ASC')
  end

end
