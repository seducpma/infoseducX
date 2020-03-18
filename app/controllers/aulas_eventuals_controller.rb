class AulasEventualsController < ApplicationController
    before_filter :load_iniciais

    def index
        @date = params[:month] ? Date.parse(params[:month]) : Date.today
        @search = AulasEventual.search(params[:search])
        if !(params[:search].blank?)
            @aulas_eventual = @search.all
#            @aulas_eventual_unidade = @search.first
        end
       session[:search]=params[:search]
          if !(params[:search].blank?)
#              params[:search][:unidade_id_equals]
              @eventual_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (month( data) = "+@date.strftime("%m")+" AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(params[:search][:unidade_id_equals]).to_s+" ) GROUP BY eventual_id")
           end

          session[:flag_show]= 1
           
  

    end

    def index2
        if current_user.unidade.tipo_id == 2   or current_user.unidade.tipo_id == 5 or  current_user.unidade.tipo_id == 8
            session[:infantil]=0
        else
            session[:infantil]=1
        end
            session[:unidade]=current_user.unidade_id

        @date = params[:month] ? Date.parse(params[:month]) : Date.today

        @search = AulasEventual.search(params[:search])

        if !(params[:search].blank?)
            @aulas_eventual = @search.all

            @aulas_eventual_unidade = @search.first

        end

        session[:flag_show]= 1

        session[:professor] =1
        session[:funcionario] =0
    end

  def destroy
        @aulas_eventual = AulasEventual.find(params[:id])
        #id=params[:id]
        @aulas_falta= AulasFalta.find(:all, :conditions => ['substituicao=?',params[:id]])
        @aulas_falta[0].substituicao=0
        @aulas_falta[0].save
        @aulas_eventual.destroy



        respond_to do |format|
            format.html { redirect_to(aulas_eventuals_url) }
            format.xml  { head :ok }
        end
    end

   def show
        @aulas_eventual = AulasEventual.find(params[:id])

        if session[:flag_show]==1
                session[:data]=0
                session[:flag_show]=0
                @falta = AulasFalta.find(:all, :conditions => ['dataI =? AND professor_id =? AND classe=?', @aulas_eventual.dataI, @aulas_eventual.professor_id, @aulas_eventual.aulas_falta.classe])
                 session[:num_faltas]= @falta.count
        end

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @aulas_eventual }
        end
    end

    def new
        @aulas_eventual = AulasEventual.new
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @aulas_eventual }
        end
    end

    def edit
        @aulas_eventual = AulasEventual.find(params[:id])
    end

    def create
            if session[:create]==0

                   w= session[:quant_falta]
                   t=0
                   i=0
                   if !params[:aulas_eventual][:dataI].nil?
                       session[:dataI]=params[:aulas_eventual][:dataI].to_date
                       session[:dataF]=params[:aulas_eventual][:dataF].to_date
                       session[:data]= session[:dataF]-session[:dataI]
                   else
                        session[:data]= 0
                   end
                   while i < session[:quant_falta] do

                         @aulas_eventual = AulasEventual.new(params[:aulas_eventual])
                         @aulas_eventual.save
                         eventual_id=@aulas_eventual.id
                         d=session[:aulas_eventual_data]   #?????
                         unidade=@aulas_eventual.unidade_id=session[:unidade_id]
                        t=0
   #                  end

                        if !session[:aulas_eventual_data].nil?
                            @aulas_eventual.data=session[:aulas_eventual_data].to_date+i
                            @aulas_eventual.dataI=session[:dataI]
                            @aulas_eventual.dataF=session[:dataF]
                            ideventual= @aulas_eventual.id
                            idfalta = session[:falta_id0].to_i +i

                            @falta= AulasFalta.find(idfalta )
                            @falta.substituicao = ideventual
                            @falta.save

                        end
                    #@aulas_eventual = AulasEventual.find(eventual_id)
                    @aulas_eventual.ano_letivo = Time.now.year
                    @aulas_eventual.aulas_falta_id= session[:falta_id]
                    #@aulas_eventual.classe = session[:classe_classe]
                    @aulas_eventual.classe_id = session[:classe_id]
                    @aulas_eventual.professor_id=session[:professor_id]

                    @aulas_eventual.save
                    i=i+1
                    end
              session[:create]=0
        else
                   i=0

                   if !params[:aulas_eventual][:dataI].nil?
                       session[:dataI]=params[:aulas_eventual][:dataI].to_date
                       session[:dataF]=params[:aulas_eventual][:dataF].to_date
                       #if session[:dataIlimite] > session[:dataI]
                       #    session[:dataI]= session[:dataIlimite]
                       #end
                       if session[:dataFlimite] < session[:dataF]
                           session[:dataF]= session[:dataFlimite]
                       end
                       session[:data]= session[:dataF]-session[:dataI]       # esta session[:data] é para contar o numero de vezes da repetição
                   else
                        session[:data]= 0
                        session[:dataI]=params[:aulas_eventual][:data].to_date
                        session[:dataF]=params[:aulas_eventual][:data].to_date

                   end


                   while i < session[:data]+1 do
                    @aulas_eventual = AulasEventual.new(params[:aulas_eventual])

                     @aulas_eventual.save
                     eventual_id=@aulas_eventual.id
                     d=session[:aulas_eventual_data]
                     unidade=@aulas_eventual.unidade_id=session[:unidade_id]
                     t=0
                        if !session[:aulas_eventual_data].nil?
                            @aulas_eventual.data=session[:aulas_eventual_data].to_date+i
                            @aulas_eventual.dataI=session[:dataI]
                            @aulas_eventual.dataF=session[:dataF]
                            ideventual= @aulas_eventual.id
                            idfalta = session[:falta_id] +i
                                @falta= AulasFalta.find(idfalta )
                            @falta.substituicao = ideventual
                            @falta.save

                        end
                    #@aulas_eventual = AulasEventual.find(eventual_id)
                    @aulas_eventual.ano_letivo = Time.now.year
                    @aulas_eventual.aulas_falta_id= session[:falta_id]
                    #@aulas_eventual.classe = session[:classe_classe]
                    @aulas_eventual.classe_id = session[:classe_id]
                    @aulas_eventual.professor_id=session[:professor_id]

                    @aulas_eventual.save
                    i=i+1
                    end
                session[:create]=0
                session[:flag_show]=0
                 
                respond_to do |format|
                        if @aulas_eventual.save
                            flash[:notice] = 'SALVO COM SUCESSO.'
                            format.html { redirect_to(@aulas_eventual) }
                            format.xml  { render :xml => @aulas_eventual, :status => :created, :location => @aulas_eventual }
                        else
                            format.html { render :action => "new" }
                            format.xml  { render :xml => @aulas_eventual.errors, :status => :unprocessable_entity }
                        end
                    end
        end
 
    
    end

    def update
        @aulas_eventual = AulasEventual.find(params[:id])
        respond_to do |format|
            if @aulas_eventual.update_attributes(params[:aulas_eventual])
                flash[:notice] = 'SALVO COM SUCESSO.'
                format.html { redirect_to(@aulas_eventual) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @aulas_eventual.errors, :status => :unprocessable_entity }
            end
        end
    end


def data_eventual
  session[:aulas_eventual_data]=  params[:aulas_eventual_data][6,4]+'-'+params[:aulas_eventual_data][3,2]+'-'+params[:aulas_eventual_data][0,2]
   
   #@aulas_falta_dia = AulasFalta.find(:all, :conditions => ['data =?', session[:aulas_eventual_data] ])
   #@aulas_falta = AulasFalta.find(:all, :conditions => ['dataI =? AND professor_id =?', @aulas_falta_dia[0].dataI, @aulas_falta_dia[0].professor_id])
   # render :partial => 'tipo_falta'
end

def periodo_prof_eventual
    w1=session[:periodo_prof_eventual]=  params[:periodo]
        @professores1= Eventual.find_by_sql("SELECT DISTINCT pro.id, CONCAT(pro.nome, ' - ',pro.funcao,' - ', MID(uni.nome,1,20),' - ', (eve.periodo) ) AS nome_categoria, eve.id, eve.regiao_id FROM eventuals eve INNER JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id INNER JOIN  "+session[:base]+".unidades uni ON  uni.id = pro.unidade_id WHERE eve.periodo = '"+session[:periodo_prof_eventual]+"' AND eve.id NOT IN (SELECT aulas_eventuals.eventual_id  FROM aulas_eventuals  WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' AND periodo = '"+session[:periodo_prof_eventual]+"') AND eve.nao_atua = 0  AND eve.regiao_id = '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC")
#        @prof_falta = Professor.find_by_sql("SELECT pro.id, CONCAT(pro.nome, ' - ',pro.funcao) AS nome_categoria FROM professors pro INNER JOIN  "+session[:baseinfo]+".aulas_faltas fal  ON  pro.id = fal.professor_id WHERE  fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +" AND fal.ano_letivo ="+(Time.now.year).to_s+" order by pro.nome DESC")
        @divisao=Eventual.find_by_sql("SELECT eve.id, CONCAT(pro.nome, ' - ',pro.funcao)AS nome_categoria FROM eventuals eve INNER JOIN "+session[:base]+".professors pro ON pro.id = eve.professor_id WHERE eve.id = (SELECT max( id )FROM eventuals ) ")
        @divisao[0].nome_categoria="----------------------------------"
        @divisao[0].id = 0
        @professores2 =  Eventual.find_by_sql("SELECT pro.id,CONCAT(pro.nome, ' - ',pro.funcao,' - ', MID(uni.nome,1,20),' - ', (eve.periodo)) AS nome_categoria, eve.id FROM eventuals eve INNER JOIN  "+session[:base]+".professors pro  ON eve.professor_id = pro.id  INNER JOIN  "+session[:base]+".unidades  uni ON  uni.id = pro.unidade_id WHERE eve.periodo = '"+session[:periodo_prof_eventual]+"' AND eve.id NOT IN (SELECT aulas_eventuals.eventual_id FROM aulas_eventuals WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"') AND eve.nao_atua = 0  AND eve.regiao_id != '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC ")
        @professores_total = @professores1 + @divisao + @professores2

    render :partial => 'selecao_professor_sub'
end


def observacao_prof_eventual
     w= params[:aulas_eventual_eventual_id]
          @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["evendual_id = ?", params[:aulas_eventual_eventual_id]])
end




#def caregoria_prof_eventual
   # w2=session[:caregoria_prof_eventual]=  params[:categoria]
#end

def nome_prof_eventual
        session[:unidade_id]=params[:aulas_eventual_unidade_id]
        @regiao= Unidade.find(:all, :conditions => ["id = ?", params[:aulas_eventual_unidade_id]])
        session[:regiao] = @regiao[0].regiao_id
    #    @date = params[:month] ? Date.parse(params[:month]) : Date.today
        session[:aulas_eventual_unidade_id]=params[:aulas_eventual_unidade_id]
        #@professores1= Eventual.find_by_sql("SELECT DISTINCT pro.id, pro.nome, eve.id, eve.regiao_id FROM eventuals eve INNER JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id INNER JOIN  "+session[:base]+".unidades uni ON  uni.id = pro.unidade_id WHERE    >>>>>     eve.periodo = '"+session[:periodo_prof_eventual]+"' AND                 <<<<<    eve.id NOT IN (SELECT aulas_eventuals.eventual_id  FROM aulas_eventuals  WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' AND aulas_eventuals.unidade_id = "+session[:aulas_eventual_unidade_id]+") AND eve.nao_atua = 0  AND eve.regiao_id = '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC")
         @professores1= Eventual.find_by_sql("SELECT DISTINCT pro.id, CONCAT(pro.nome, ' - ',pro.funcao,' - ',  MID(uni.nome,1,20)) AS nome_categoria, eve.id, eve.regiao_id FROM eventuals eve INNER JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id INNER JOIN  "+session[:base]+".unidades uni ON  uni.id = pro.unidade_id WHERE  eve.id NOT IN (SELECT aulas_eventuals.eventual_id  FROM aulas_eventuals  WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"') AND eve.nao_atua = 0  AND eve.regiao_id = '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC")
#        @prof_falta = Professor.find_by_sql("SELECT pro.id, CONCAT(pro.nome, ' - ',pro.funcao) AS nome_categoria FROM professors pro INNER JOIN  "+session[:baseinfo]+".aulas_faltas fal  ON  pro.id = fal.professor_id WHERE  fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +" AND fal.ano_letivo ="+(Time.now.year).to_s+" order by pro.nome DESC")
        @divisao=Eventual.find_by_sql("SELECT eve.id, CONCAT(pro.nome, ' - ',pro.funcao)AS nome_categoria FROM eventuals eve INNER JOIN "+session[:base]+".professors pro ON pro.id = eve.professor_id WHERE eve.id = (SELECT max( id )FROM eventuals ) ")
        @divisao[0].nome_categoria="----------------------------------"
        @divisao[0].id = 0
        #@professores2 =  Eventual.find_by_sql("SELECT pro.id, pro.nome, eve.id FROM eventuals eve INNER JOIN  "+session[:base]+".professors pro  ON eve.professor_id = pro.id  INNER JOIN  "+session[:base]+".unidades  uni ON  uni.id = pro.unidade_id WHERE >>>>>   eve.periodo = '"+session[:periodo_prof_eventual]+"' AND <<<<<< eve.id NOT IN (SELECT aulas_eventuals.eventual_id FROM aulas_eventuals WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' AND aulas_eventuals.unidade_id = '"+session[:aulas_eventual_unidade_id].to_s+"') AND eve.nao_atua = 0  AND eve.regiao_id != '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC ")
        @professores2 =  Eventual.find_by_sql("SELECT pro.id,CONCAT(pro.nome, ' - ',pro.funcao,' - ',  MID(uni.nome,1,20)) AS nome_categoria, eve.id FROM eventuals eve INNER JOIN  "+session[:base]+".professors pro  ON eve.professor_id = pro.id  INNER JOIN  "+session[:base]+".unidades  uni ON  uni.id = pro.unidade_id WHERE  eve.id NOT IN (SELECT aulas_eventuals.eventual_id FROM aulas_eventuals WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' ) AND eve.nao_atua = 0  AND eve.regiao_id != '"+session[:regiao].to_s+"' GROUP BY pro.id ORDER BY  pro.nome ASC ")
       @professores_total = @professores1 + @divisao + @professores2
        @classes = Classe.find(:all,:select => 'id, classe_classe', :conditions =>['unidade_id =? and  classe_ano_letivo=?',  session[:aulas_eventual_unidade_id], Time.now.year], :order => 'classe_classe')
        @interno= Eventual.find_by_sql("SELECT aulas_eventuals.eventual_id FROM aulas_eventuals WHERE aulas_eventuals.ano_letivo ="+(Time.now.year).to_s+" AND data = '"+session[:aulas_eventual_data].to_s+"' AND aulas_eventuals.unidade_id = "+session[:aulas_eventual_unidade_id]+" " )
        #@prof_falta = Professor.find_by_sql("SELECT pro.id, CONCAT(pro.nome, ' - ',pro.funcao) AS nome_categoria FROM professors pro INNER JOIN  "+session[:baseinfo]+".aulas_faltas fal  ON  pro.id = fal.professor_id WHERE  fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +" AND fal.ano_letivo ="+(Time.now.year).to_s+ " order by pro.nome DESC")
#        @prof_falta = Professor.find_by_sql("SELECT pro.id, CONCAT(pro.nome, ' - ',pro.funcao) AS nome_categoria FROM professors pro INNER JOIN  "+session[:baseinfo]+".aulas_faltas fal  ON  pro.id = fal.professor_id WHERE  fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +" AND fal.ano_letivo ="+(Time.now.year).to_s+ " AND fal.professor_id NOT IN ( SELECT  aul.professor_idx FROM eventuals eve INNER JOIN  "+session[:baseinfo]+'.aulas_eventuals aul  ON  eve.id = aul.eventual_id   WHERE aul.data =  "' + session[:aulas_eventual_data] + '") order by pro.nome DESC")')
#anterior        @prof_falta = Professor.find_by_sql("SELECT pro.id, CONCAT( pro.nome, ' - ', fal.classe ) AS classe_falta FROM professors pro INNER JOIN "+session[:baseinfo]+".aulas_faltas fal ON pro.id = fal.professor_id  WHERE fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +"AND fal.ano_letivo = "+(Time.now.year).to_s+ " AND fal.professor_id NOT IN (SELECT fal.professor_id FROM  "+session[:baseinfo]+".aulas_eventuals eaul JOIN  "+session[:baseinfo]+".aulas_faltas fal ON eaul.aulas_falta_id = fal.id  WHERE fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +") ORDER BY pro.nome DESC")
          @prof_falta = Professor.find_by_sql("SELECT pro.id, fal.id AS faltaid ,CONCAT( pro.nome, ' - ', fal.classe, ' - ', fal.periodo) AS classe_falta FROM professors pro INNER JOIN "+session[:baseinfo]+".aulas_faltas fal ON pro.id = fal.professor_id  WHERE fal.unidade_id = "+session[:aulas_eventual_unidade_id]+" AND fal.data = "+'"'+ session[:aulas_eventual_data]+'"' +"AND fal.ano_letivo = "+(Time.now.year).to_s+ " AND fal.substituicao = 0 ORDER BY pro.nome DESC")
        if @professores_total.present?
           render :partial => 'selecao_professor'
        else
           render :partial => 'aviso'
        end
    end





def aulas_faltas_prof_classe
    t=0
  if session[:prof_falt]==1
      w1=session[:aulas_falta_id] = params[:aulas_eventual_aulas_falta_id]
       @aula_falta= AulasFalta.find(:all, :conditions => ['id=? AND data =?', params[:aulas_eventual_aulas_falta_id], session[:aulas_eventual_data]] )
       session[:professor_id]=@aula_falta[0].professor.id
       #@classe= Classe.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.classe_id = classes.id INNER JOIN professors ON atribuicaos.professor_id = professors.id ", :conditions=>[ "atribuicaos.professor_id = ? AND atribuicaos.ano_letivo = ?" , session[:professor_id], Time.now.year]  )
#       @classe= Classe.find(:all, :joins => "INNER JOIN "+session[:base]+"aulas.faltas ON aulas_faltas.classe = classes.classe_classe id", :conditions=>[ "'+session[:base]+'.aulas_faltas.id = ? ",session[:aulas_falta_id]]  )
### Alex 2019-05-24 12:31 Ini
       if @aula_falta[0].classe=="PA"
            session[:classe_classe]="PA"
            session[:classe_id]=0
       else
            @classe= Classe.find(:all, :joins => "INNER JOIN atribuicaos atr ON atr.classe_id = classes.id INNER JOIN professors  pro ON atr.professor_id = pro.id INNER JOIN  "+session[:baseinfo]+".aulas_faltas falt ON falt.classe = classes.classe_classe", :conditions=>[ "atr.professor_id = ? AND atr.ano_letivo = ? AND classes.unidade_id = falt.unidade_id AND falt.id =?" , session[:professor_id], Time.now.year, session[:aulas_falta_id] ]  )
           if @classe.empty?
              session[:classe_id]= nil
           else
           
              session[:classe_id]=@classe[0].id
              session[:classe_classe]=@classe[0].classe_classe
           end
       end
### Alex 2019-05-24 12:31 Fim
#        @classe= Classe.find(:all, :joins => "xxx INNER JOIN atribuicaos atr ON atr.classe_id = classes.id INNER JOIN professors  pro ON atr.professor_id = pro.id INNER JOIN  "+session[:baseinfo]+".aulas_faltas falt ON falt.classe = classes.classe_classe", :conditions=>[ "atr.professor_id = ? AND atr.ano_letivo = ? AND classes.unidade_id = falt.unidade_id AND falt.id =?" , session[:professor_id], Time.now.year, session[:aulas_falta_id] ]  )
#       w5=session[:classe_id]=@classe[0].id
#       w6=session[:classe_classe]=@classe[0].classe_classe
       w2=session[:falta_id]= @aula_falta[0].id
       w3=session[:prof_falt] = 0
       w4=session[:aulas_eventual_data]
      @aulas_falta_dia = AulasFalta.find(:all, :conditions => ['data =?', session[:aulas_eventual_data] ])
      @aulas_falta = AulasFalta.find(:all, :conditions => ['id =? AND professor_id =?', session[:falta_id],  session[:professor_id]])
      @falta = AulasFalta.find(:all, :conditions => ['dataI =? AND professor_id =? AND classe=?', @aulas_falta[0].dataI, session[:professor_id], session[:classe_classe]])
      session[:num_faltas]= @falta.count
      session[:tipo_falta]=@aulas_falta[0].tipo
      t=0
           render :partial => 'proffalta'
  else
      w= params[:aulas_eventual_eventual_id]
           #@professors = Eventual.find(:all, :conditions =>  ["id = ?", params[:aulas_eventual_eventual_id]])
           @professors = Eventual.find_by_sql("SELECT uni.nome AS unidade_nome, uni.fone AS unidade_fone, eve.id, pro.telefone AS contato1, pro.telefone AS contato2, eve.id, eve.contato AS contato3, eve.disponibilidade , eve.obs AS observacao FROM eventuals eve LEFT JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id LEFT JOIN "+session[:base]+".unidades uni ON uni.id = pro.unidade_id  WHERE eve.id ="+params[:aulas_eventual_eventual_id]+"")
        render :partial => 'observacaos'

  end
end







def aulas_faltas_prof_classe_anterior
  if session[:prof_falt]==1
      w1=session[:professor_id] = params[:aulas_eventual_professor_id]
       @aula_falta= AulasFalta.find(:all, :conditions => ['professor_id=? AND data =?', params[:aulas_eventual_professor_id], session[:aulas_eventual_data]] )
       @classe= Classe.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.classe_id = classes.id INNER JOIN professors ON atribuicaos.professor_id = professors.id ", :conditions=>[ "atribuicaos.professor_id = ? AND atribuicaos.ano_letivo = ?" , session[:professor_id], Time.now.year]  )
       w1=session[:classe_id]=@classe[0].id
       w2=session[:falta_id]= @aula_falta[0].id
       w3=session[:prof_falt] = 0
       w4=session[:aulas_eventual_data]
      @aulas_falta_dia = AulasFalta.find(:all, :conditions => ['data =?', session[:aulas_eventual_data] ])
      @aulas_falta = AulasFalta.find(:all, :conditions => ['id =? AND professor_id =?', session[:falta_id],  session[:professor_id]])



     @falta = AulasFalta.find(:all, :conditions => ['dataI =? AND professor_id =?', @aulas_falta[0].dataI, session[:professor_id]])


     
      session[:num_faltas]= @falta.count
      session[:tipo_falta]=@aulas_falta[0].tipo
      t=0
           render :partial => 'proffalta'
           t
  else
      w= params[:aulas_eventual_eventual_id]
           #@professors = Eventual.find(:all, :conditions =>  ["id = ?", params[:aulas_eventual_eventual_id]])
           @professors = Eventual.find_by_sql("SELECT uni.nome AS unidade_nome, uni.fone AS unidade_fone, eve.id, pro.telefone AS contato1, pro.telefone AS contato2, eve.id, eve.contato AS contato3, eve.disponibilidade , eve.obs AS observacao FROM eventuals eve LEFT JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id LEFT JOIN "+session[:base]+".unidades uni ON uni.id = pro.unidade_id  WHERE eve.id ="+params[:aulas_eventual_eventual_id]+"")
        render :partial => 'observacaos'
       
  end
end


    def observacao_prof_eventual
        @professor = Eventual.find(:all, :conditions => ['id = ?',  params[:aulas_eventual_eventual_id]] )
        render :partial => 'observacaos'
    end


    def impressao_unidade
         @date = params[:month] ? Date.parse(params[:month]) : Date.today
        @search = AulasEventual.search(session[:search])
        if !(session[:search].blank?)
            @aulas_eventual = @search.all
            @aulas_eventual_unidade = @search.first
        end

       render :layout => "impressao"
    end

def relatorios_eventual_professor
    session[:tiporelatorio]=2
    session[:aulas_professor_id]=params[:aulas_eventual][:eventual_id]
    w=session[:verifica_professor_id]=params[:aulas_eventual][:eventual_id]
    session[:dia_final]=params[:diaF]
    session[:mesF]=params[:mesF]
    session[:dataI]=params[:aulas_falta][:dataI][6,4]+'-'+params[:aulas_falta][:dataI][3,2]+'-'+params[:aulas_falta][:dataI][0,2]
    session[:dataF]=params[:aulas_falta][:dataF][6,4]+'-'+params[:aulas_falta][:dataF][3,2]+'-'+params[:aulas_falta][:dataF][0,2]
   session[:dataI_tela]=params[:aulas_falta][:dataI][0,2]+'-'+params[:aulas_falta][:dataI][3,2]+'-'+params[:aulas_falta][:dataI][6,4]
    session[:dataF_tela]=params[:aulas_falta][:dataF][0,2]+'-'+params[:aulas_falta][:dataF][3,2]+'-'+params[:aulas_falta][:dataF][6,4]

    session[:mes]=params[:aulas_falta][:dataF][3,2]
    session[:mostra_eventual_professor] = 1
        if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? AND eventual_id=?", session[:dataI].to_s, session[:dataF].to_s, params[:aulas_eventual][:eventual_id]], :order => 'data ASC')
    @eventual_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' AND eventual_id ="+(session[:verifica_professor_id]).to_s+" ) GROUP BY eventual_id")
    session[:imprimeprofessor] = 1
    session[:mostra_faltas_professor] = 1
       render :update do |page|
          page.replace_html 'calendario', :partial => 'eventuals'
       end
end


 def relatorios_eventuals
    session[:tiporelatorio]=1
    session[:dia_final]=params[:diaF]
    session[:mesF]=params[:mesF]
    session[:dataI]=params[:aulas_falta][:dataI][6,4]+'-'+params[:aulas_falta][:dataI][3,2]+'-'+params[:aulas_falta][:dataI][0,2]
    session[:dataF]=params[:aulas_falta][:dataF][6,4]+'-'+params[:aulas_falta][:dataF][3,2]+'-'+params[:aulas_falta][:dataF][0,2]
    session[:mes]=params[:aulas_falta][:dataF][3,2]
    w=session[:verifica_unidade_id]=params[:aulas_eventual][:unidade_id]
    t=0
        if session[:mes] == '01'
            session[:mes] = 'JANEIRO'
        else if session[:mes] == '02'
                session[:mes] = 'FEVEREIRO'
            else if session[:mes] == '03'
                    session[:mes] = 'MARÇO'
                else if session[:mes] == '04'
                        session[:mes] = 'ABRIL'
                    else if params[:mes] == '05'
                            session[:mes] = 'MAIO'
                        else if session[:mes] == '06'
                                session[:mes] = 'JUNHO'
                            else if session[:mes] == '07'
                                    session[:mes] = 'JULHO'
                                else if session[:mes] == '08'
                                        session[:mes] = 'AGOSTO'
                                    else if session[:mes] == '09'
                                            session[:mes] = 'SETEMBRO'
                                        else if session[:mes] == '10'
                                                session[:mes] = 'OUTUBRO'
                                            else if session[:mes] == '11'
                                                    session[:mes] = 'NOVEMBRO'
                                                else if session[:mes] == '12'
                                                        session[:mes] = 'DEZEMBRO'
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    session[:mostra_eventuals_professor] = 1
    session[:aulas_eventual_unidade_id] = params[:aulas_eventual][:unidade_id]
     if (session[:verifica_unidade_id]=='52')
         @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? ", session[:dataI].to_s, session[:dataF].to_s], :order => 'data ASC')
         @eventual_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"'  AND eventual_id IS NOT NULL) GROUP BY eventual_id")
         session[:imprimemes] = 1
     else
         @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? AND unidade_id=?", session[:dataI].to_s, session[:dataF].to_s, params[:aulas_eventual][:unidade_id]], :order => 'data ASC')
         @eventual_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND eventual_id IS NOT NULL) GROUP BY eventual_id")
         session[:imprimemes] = 1
     end
       render :update do |page|
           page.replace_html 'calendario', :partial => 'eventuals'
       end
end

def impressao_eventuals
     if (session[:verifica_unidade_id]=='52')
         @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? AND ano_letivo=? ", session[:dataI].to_s, session[:dataF].to_s, Time.now.year], :order => 'data ASC')
         @eventuals_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' AND ano_letivo = "+(Time.now.year).to_s+" AND eventual_id IS NOT NULL) GROUP BY eventual_id")
     else
         @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? AND  ano_letivo=? AND unidade_id=?",session[:dataI].to_s, session[:dataF].to_s, Time.now.year, session[:aulas_eventual_unidade_id]], :order => 'data ASC')
         @eventuals_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' AND ano_letivo = "+(Time.now.year).to_s+" AND unidade_id ="+(session[:verifica_unidade_id]).to_s+" AND eventual_id IS NOT NULL) GROUP BY eventual_id")
     end
    render :layout => "impressao"
end

def impressao_eventuals_professor
    session[:verifica_professor_id]
    @aulas_eventuals = AulasEventual.find(:all, :conditions =>  ["data between ? and ? AND ano_letivo=? AND eventual_id=?", session[:dataI].to_s, session[:dataF].to_s, Time.now.year,  session[:verifica_professor_id]], :order => 'data ASC')
    @eventual_professor = AulasEventual.find_by_sql("SELECT eventual_id, count( id ) as conta FROM aulas_eventuals WHERE (data BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"'  AND ano_letivo = "+(Time.now.year).to_s+" AND eventual_id ="+(session[:verifica_professor_id]).to_s+" AND eventual_id IS NOT NULL ) GROUP BY eventual_id")
    render :layout => "impressao"
end

    def load_iniciais
        #session[:base]= 'sisgered_development'
         #session[:base]= 'sis3ered_production'
             if current_user.has_role?('admin') or current_user.has_role?('SEDUC') or  current_user.has_role?('estagiario SEDUC')
                @unidades_infantil = Unidade.find(:all,  :select => 'nome, id',:conditions =>  ["tipo_id = 2 OR tipo_id = 5 OR tipo_id = 8 OR id=52"], :order => 'nome ASC')
    #            @professores_eventual= AulasEventual.find_by_sql("SELECT DISTINCT(pro.id), pro.nome, eve.id FROM aulas_eventuals aev LEFT JOIN  eventuals eve ON aev.eventual_id = eve.id LEFT JOIN "+session[:base]+".professors pro ON aev.professor_id = pro.id WHERE eve.ano_letivo = "+(Time.now.year).to_s+" ORDER BY pro.nome")
             else
                @unidades_infantil = Unidade.find(:all,  :select => 'nome, id', :conditions =>  ["id=?", current_user.unidade_id], :order => 'nome ASC')
    #            @professores_eventual= AulasEventual.find_by_sql("SELECT DISTINCT(pro.id), pro.nome, eve.id FROM aulas_eventuals aev LEFT JOIN  eventuals eve ON aev.eventual_id = eve.id LEFT JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id WHERE eve.ano_letivo = "+(Time.now.year).to_s+"  AND aev.unidade_id = "+(current_user.unidade_id).to_s+"  ORDER BY pro.nome")
             end
          @professores_eventual= AulasEventual.find_by_sql("SELECT DISTINCT(pro.id) AS idpro, pro.nome, eve.id AS ideve , aev.eventual_id AS idaev FROM aulas_eventuals aev LEFT JOIN  eventuals eve ON aev.eventual_id = eve.id LEFT JOIN "+session[:base]+".professors pro ON aev.professor_id = pro.id WHERE eve.ano_letivo = "+(Time.now.year).to_s+" ORDER BY pro.nome")
          @professores_eventual_infantil= Eventual.find_by_sql("SELECT pro.id, pro.nome, eve.id FROM eventuals eve LEFT JOIN "+session[:base]+".professors pro ON eve.professor_id = pro.id WHERE eve.ano_letivo = 'Time.now.year).to_s +' ORDER BY pro.nome")
    end
end
