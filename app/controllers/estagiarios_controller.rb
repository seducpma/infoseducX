class EstagiariosController < ApplicationController

  before_filter :load_iniciais

 def load_iniciais
      @estagiariosa = Estagiario.find(:all, :order => 'nome ASC',:conditions => ['flag=? and desligado=?',0,0])
      @periodos = Estagiario.find(:all,:select =>'distinct(periodo_est)', :order=> 'periodo_est DESC' )
      @estagios =TiposEstagio.find(:all, :select => 'nome',:order => 'nome ASC')
      #@unidades = Unidade.find(:all, :conditions => ['status = 1'], :order => 'nome ASC')
      #@unidades1 = Unidade.find(:all, :select => 'nome, id', :conditions => ['id != 9 and id != 12 and id != 65 and id != 62 and id != 71 and id != 72 and id != 75 and id != 76 and id != 79 and id != 59', ], :order => 'nome ASC')
      @tiposEstagio = TiposEstagio.find(:all, :order => 'nome ASC')
      if current_user.unidade_id == 52 or current_user.unidade_id == 53
           @estagiarios = Estagiario.find(:all, :conditions =>['desligado = 0'], :order => 'nome ASC')
      else
          @estagiarios = Estagiario.find(:all, :conditions =>['unidade_id =? AND desligado = 0', current_user.unidade_id], :order => 'nome ASC')
      end
 end

  def mesmo_nome

    w=session[:nome] = params[:estagiario_nome]

    @verifica = Estagiario.find(:all, :conditions=> ['nome =? ',params[:estagiario_nome]])

    if @verifica.present? then
      render :update do |page|
        page.replace_html 'certeza', :text => '<font color="red" id="pisca1"> NOME JÁ CADASTRADO NO SISTEMA </font>'
         page.replace_html 'certeza1', :text => '<font color="red" id="pisca1"> NOME JÁ CADASTRADO NO SISTEMA </font>'
      end
    end
  end


def lista_consulta_estagiario
      @estagiarios = Estagiario.find(:all, :conditions => ['desligado =0 and id= ?', params[:estagiario_id]])
    render :partial => 'estagiarios'
 end

 def lista_consulta_periodo_est
      @estagiarios = Estagiario.find(:all, :conditions => ['desligado =0 and periodo_est= ? and unidade_id=?' ,  params[:estagiario_periodo_est], current_user.unidade_id])
    render :partial => 'estagiarios'
 end

 def lista_consulta_tipo
      @estagiarios = Estagiario.find(:all, :conditions => ['desligado =0 and tipo= ? and unidade_id=?',  params[:estagiario_tipo], current_user.unidade_id])
    render :partial => 'estagiarios'
 end

 def lista_consulta_unidade
      @estagiarios = Estagiario.find(:all, :conditions => ['desligado =0 and unidade_id= ?',  params[:estagiario_unidade_id]])
    render :partial => 'estagiarios'
 end

def consulta_estagiario
    if params[:type_of].to_i == 5
            @estagiarios = Estagiario.find(:all, :conditions => ['desligado =1 '])
           render :update do |page|
                page.replace_html 'dados', :partial => "estagiarios"
              end
         else if params[:type_of].to_i == 6
            @estagiarios = Estagiario.find(:all, :conditions => ['desligado =0 '])
               render :update do |page|
                    page.replace_html 'dados', :partial => "estagiarios"
                  end
              end
    end
  end

  def index
    @estagiarios = Estagiario.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @estagiarios }
    end
  end

  def show
    @estagiario = Estagiario.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @estagiario }
    end
  end

  def new
    @estagiario = Estagiario.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @estagiario }
    end
  end

  def edit
    @estagiario = Estagiario.find(params[:id])
  end

  def create
    @estagiario = Estagiario.new(params[:estagiario])

    w= @estagiario.photo_file_name
    t=0
    respond_to do |format|
      if @estagiario.save

        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@estagiario) }
        format.xml  { render :xml => @estagiario, :status => :created, :location => @estagiario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @estagiario.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @estagiario = Estagiario.find(params[:id])
    respond_to do |format|
      if @estagiario.update_attributes(params[:estagiario])
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@estagiario) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @estagiario.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @estagiario = Estagiario.find(params[:id])
    @estagiario.destroy
    respond_to do |format|
      format.html { redirect_to(estagiarios_url) }
      format.xml  { head :ok }
    end
  end
end
