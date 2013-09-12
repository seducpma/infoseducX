class ParticipantesController < ApplicationController
  # GET /participantes
  # GET /participantes.xml

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
      @participante.telefone = params[:telefone]
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
      #@turno_op2 = Inscricao.find_all_by_periodo_opcao2(params[:turno])

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

  # GET /participantes/1
  # GET /participantes/1.xml
  def show
    @participante = Participante.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participante }
    end
  end

  # GET /participantes/new
  # GET /participantes/new.xml
  def new
    @participante = Participante.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participante }
    end
  end

  # GET /participantes/1/edit
  def edit
    @participante = Participante.find(params[:id])
  end

  # POST /participantes
  # POST /participantes.xml
  def create
    @participante = Participante.new(params[:participante])

    respond_to do |format|
      if @participante.save
        flash[:notice] = 'Participante was successfully created.'
        format.html { redirect_to(@participante) }
        format.xml  { render :xml => @participante, :status => :created, :location => @participante }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participantes/1
  # PUT /participantes/1.xml
  def update
    @participante = Participante.find(params[:id])

    respond_to do |format|
      if @participante.update_attributes(params[:participante])
        flash[:notice] = 'Participante was successfully updated.'
        format.html { redirect_to(@participante) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participantes/1
  # DELETE /participantes/1.xml
  def destroy
    @participante = Participante.find(params[:id])
    @participante.destroy

    respond_to do |format|
      format.html { redirect_to(participantes_url) }
      format.xml  { head :ok }
    end
  end

  def consulta
    #render :partial => 'consultas'
  end


  def lista_participante
    @inscricao = Inscricao.find_by_participante_id(params[:participante_participante_id])
    render :partial => 'lista_participantes'
  end

  def lista_participante1
    @inscricao = Inscricao.find_by_participante_id(params[:participante_participante_id])
    render :partial => 'lista_participantes'
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

  protected
  def load_unidades
    @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

  def load_participantes
    @participantes = Participante.find(:all, :order => 'nome ASC')
  end

end
