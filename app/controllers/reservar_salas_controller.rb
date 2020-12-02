class ReservarSalasController < ApplicationController

before_filter :load_salas
before_filter :load_servicos_salas
layout :define_layout
before_filter :login_required, :except => ["doc_orientador_A","doc_orientador_5","doc_orientador_4","doc_orientador_3","doc_orientador_1","doc_orientador_fun_01","doc_orientador_inf_01","cesta_basica", "uso_internet", "dowloads",  "plano_educacao", "banco_horas", "index", "show", "create", "new","edit","sel_dados", "confirma", "confirma_agenda", "infantil_2019", "fundamental_2019",  "fundamental_2020",  "infantil_2020", "infantil_2020_1",  "infantil_2020_2", "acordo_2020", "diarioinfantil_2020", "protocolo_covid","ensino_fundamental","educacao_infantil", "fonofundamental", "fonoinfantil","material"]

 def load_servicos_salas
  @servicos_salas = ServicosSala.find(:all, :conditions=>['status = 1'] )
  end

 def load_salas
  @salas = Sala.find(:all, :order => "sala ASC" , :conditions=>['status = 1'])
  end

  def index
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @reservar_salas = ReservarSala.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reservar_salas }
    end
  end

def impressao_calendar
  @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @reservar_salas = ReservarSala.all

  render :layout => "impressao_calendar"
  end



  def show
    @reservar_sala = ReservarSala.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reservar_sala }
    end
  end

  def new
    @reservar_sala = ReservarSala.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reservar_sala }
    end
  end

  def edit
    @reservar_sala = ReservarSala.find(params[:id])
  end

def create
    @reservar_sala = ReservarSala.new(params[:reservar_sala])
    $salareserva = @reservar_sala.sala_id
    $datareserva = @reservar_sala.data_reserva
    $horareservai = (@reservar_sala.horario_reservai).to_time
    $horareservaf = (@reservar_sala.horario_reservaf).to_time
    @reservado =ReservarSala.find(:all, :conditions => ['sala_id = ? and data_reserva = ? and horario_reservai <= ? and horario_reservaf >= ?', $salareserva, $datareserva, $horareservai, $horareservai  ])
    if (@reservar_sala.horario_reservaf.hour < @reservar_sala.horario_reservai.hour)
      respond_to do |format|
       flash[:notice] = 'HORÁRIO DE ENCERRAMENTO MAIOR QUE HORÁRIO DE INICIO.'
       format.html { redirect_to new_reservar_sala_path }
       format.xml  { head :ok }
     end
   else
    #if   (@reservar_sala.data_reserva >= (DateTime.now.to_date + 1))
    if   (@reservar_sala.data_reserva >= (DateTime.now.to_date ))
     if ((@reservado.present? ))
     respond_to do |format|
       flash[:notice] = 'JÁ EXISTE RESERVA PARA ESTE DIA E HORA.'
       format.html { redirect_to reservar_salas_path }
       format.xml  { head :ok }
     end
    else
     respond_to do |format|
          if @reservar_sala.save
            flash[:notice] = 'RESERVADO COM SUCESSO.'
            format.html { redirect_to(@reservar_sala) }
            format.xml  { render :xml => @reservar_sala, :status => :created, :location => @reservar_sala }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @reservar_sala.errors, :status => :unprocessable_entity }
          end
        end
    end
    else
       respond_to do |format|
       flash[:notice] = 'RESERVA DEVE SER FEITA COM 24 HORAS DE ANTECEDÊNCIA.'
       format.html { redirect_to reservar_salas_path }
       format.xml  { head :ok }
     end
    end
  end
 end

  def update
    @reservar_sala = ReservarSala.find(params[:id])
    respond_to do |format|
      if @reservar_sala.update_attributes(params[:reservar_sala])
        flash[:notice] = 'RESERVADO COM SUCESSO.'
        format.html { redirect_to(@reservar_sala) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reservar_sala.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @reservar_sala = ReservarSala.find(params[:id])
    @reservar_sala.destroy
    respond_to do |format|
      format.html { redirect_to(reservar_salas_url) }
      format.xml  { head :ok }
    end
  end


  def define_layout
    if logged_in?
      'application'
    else
      'inscricao'
    end
  end


def confirma_agenda

end

 def sel_dados
    @dados = Sala.find(params[:reservar_sala_sala_id])
    session[:reservasala]= params[:reservar_sala_sala_id]
    render :partial => 'exibe_dados'
  end

 def sel_data
     session[:reservadata]= params[:reservar_sala_data_reserva]
 end

# para download acrescentar a def no "before_filter"
def dowloads
    
end


def diarioinfantil_2020
    send_file("#{RAILS_ROOT}/public/documentos/DiarioInfantil2020.pdf" , :type=>"pdf")
end


def protocolo_covid
  send_file("#{RAILS_ROOT}/public/documentos/protocolo.pdf" , :type=>"pdf")
end



def fundamental_2020
    #send_file("#{RAILS_ROOT}/public/documentos/Fundamental_2018.pdf" , :type=>"pdf")
    send_file("#{RAILS_ROOT}/public/documentos/Fundamental2020.xls" , :type=>"xls")
end

def infantil_2020
    send_file("#{RAILS_ROOT}/public/documentos/Infantil2020.xls" , :type=>"xls")
end

def infantil_2020_1
    send_file("#{RAILS_ROOT}/public/documentos/infantil_2020_1.xls" , :type=>"xls")
end

def infantil_2020_2
    send_file("#{RAILS_ROOT}/public/documentos/infantil_2020_2.xls" , :type=>"xls")
end

def doc_orientador_inf_01
    send_file("#{RAILS_ROOT}/public/documentos/documento_orientador_1_infantil.pdf" , :type=>"pdf")
end

def doc_orientador_fun_01
    send_file("#{RAILS_ROOT}/public/documentos/documento_orientador_1_fundamental.pdf" , :type=>"pdf")
end

def doc_orientador_1
    send_file("#{RAILS_ROOT}/public/documentos/Documento Orientador n º 1.pdf" , :type=>"pdf")
end

def doc_orientador_3
    send_file("#{RAILS_ROOT}/public/documentos/Documento Orientador n º 3.pdf" , :type=>"pdf")
end
def doc_orientador_4
    send_file("#{RAILS_ROOT}/public/documentos/Documento Orientador n º 4.pdf" , :type=>"pdf")
end
def doc_orientador_5
    send_file("#{RAILS_ROOT}/public/documentos/Documento Orientador n º 5.pdf" , :type=>"pdf")
end
def doc_orientador_A
    send_file("#{RAILS_ROOT}/public/documentos/Documento Orientador n º A.pdf" , :type=>"pdf")
end

def acordo_2020
    send_file("#{RAILS_ROOT}/public/documentos/acordo_2020.pdf" , :type=>"pdf")
end


def infantil_2019
    send_file("#{RAILS_ROOT}/public/documentos/Infantil2019.xls" , :type=>"xls")
end

def fundamental_2019
     send_file("#{RAILS_ROOT}/public/documentos/Fundamental2019.xls" , :type=>"xls")
end

def cesta_basica
    send_file("#{RAILS_ROOT}/public/documentos/Lei 6166.pdf" , :type=>"pdf")
end

def plano_educacao
    send_file("#{RAILS_ROOT}/public/documentos/plano_educacao.pdf" , :type=>"pdf")
end

def banco_horas
    send_file("#{RAILS_ROOT}/public/documentos/banco_horas.pdf" , :type=>"pdf")
end

def educacao_infantil
    send_file("#{RAILS_ROOT}/public/documentos/Infantil.pdf" , :type=>"pdf")
end

def ensino_fundamental
  send_file("#{RAILS_ROOT}/public/documentos/Fundamental.pdf" , :type=>"pdf")
end

def uso_internet
    send_file("#{RAILS_ROOT}/public/documentos/Uso_Internet.ppsx", :type=>"ppsx")
end


def fonoinfantil
  send_file("#{RAILS_ROOT}/public/documentos/FonoInfantil.pdf" , :type=>"pdf")
end

def fonofundamental
  send_file("#{RAILS_ROOT}/public/documentos/FonoFundamental.pdf" , :type=>"pdf")
end



def material
  send_file("#{RAILS_ROOT}/public/documentos/MaterialEscolar.pdf" , :type=>"pdf")
end



end
