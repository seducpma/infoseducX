class AtribuicaosController < ApplicationController

    before_filter :load_professors
    before_filter :load_classes

    def index
        @atribuicaos = Atribuicao.all
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @atribuicaos }
        end
    end

    def show
        @atribuicao = Atribuicao.find(params[:id])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @atribuicao }
        end
    end

    def show_editar
        @atribuicao = Atribuicao.find(session[:atribuicao])
    end

    def new
        @atribuicao = Atribuicao.new
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @atribuicao }
        end
    end


    def edit
        if session[:flag_edit_atribuicao] == 1
            @atribuicao_anterior = Atribuicao.find(:all, :conditions=>['id =?', (params[:id])])
            session[:disciplina_id]=  @atribuicao_anterior[0].disciplina_id
            session[:disciplina_nome]=  @atribuicao_anterior[0].disciplina.disciplina
            session[:professora_id]=  @atribuicao_anterior[0].professor_id
            session[:professor_nome]=  @atribuicao_anterior[0].professor.nome
            @atribuicao = Atribuicao.find(params[:id])
        else
            @atribuicao = Atribuicao.find(params[:id])
            @notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND aluno_id = ? AND notas.ano_letivo=?", session[:atrib_id],  session[:aluno_id],Time.now.year ])
            session[:flag_edit]=1
        end
    end

    def create
        @atribuicao = Atribuicao.new(params[:atribuicao])
        session[:classe]= @atribuicao.classe_id
        session[:professor]= @atribuicao.professor_id
        session[:disciplina]=@atribuicao.disciplina_id
        @verifica = Atribuicao.find(:all, :select => 'id', :conditions => ['classe_id =? AND professor_id =? AND disciplina_id=? AND ano_letivo=?',@atribuicao.classe_id, @atribuicao.professor_id, @atribuicao.disciplina_id, Time.now.year])
        if @verifica.present? then
            flash[:notice] = 'ESTE PROFESSOR JÁ ESTÁ ATRIBUIDO PARA ESTA CLASSE NESTA DISCIPLINA!'
            respond_to do |format|
                format.html { render :action => "new" }
            end
        else
            respond_to do |format|
                if @atribuicao.save
                    flash[:notice] = 'SALVO COM SUCESSO!'
                    format.html { redirect_to(@atribuicao) }
                    format.xml  { render :xml => @atribuicao, :status => :created, :location => @atribuicao }
                else
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                end
            end
        end
    end


    def create_observacao_historico
        params[:observacao_historico]
        @observacao_historico = ObservacaoHistorico.new(params[:observacao_historico])
        @historico_aluno  = Aluno.find(session[:historico_aluno_id])
        @observacao_historico.aluno_id = @aluno.id
        @observacao_historico.data = Time.now
        if @observacao_historico.save
            render :update do |page|
                page.replace_html 'dados', :partial => "observacoes"
                page.replace_html 'edit'
            end
        end
    end

    def update
        @atribuicao = Atribuicao.find(params[:id])
        if session[:flag_edit_atribuicao] == 1
            session[:atribuicao]=params[:id]
            respond_to do |format|
                if @atribuicao.update_attributes(params[:atribuicao])
                    @notas = Nota.find(:all, :conditions=> ['atribuicao_id=? and disciplina_id=?', @atribuicao.id, session[:disciplina_id]])
                    for nota in @notas
                        nota = Nota.find(nota.id)
                        nota.disciplina_id=@atribuicao.disciplina_id
                        nota.professor_id=@atribuicao.professor_id
                        nota.save
                    end
                    flash[:notice] = 'Atribuição atualizada.'
                    format.html { redirect_to( show_editar_path ) }
                    format.xml  { head :ok }
                else
                    format.html { render :action => "edit" }
                    format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                end
            end
        else
            @outras_atribuicaos = Atribuicao.find(:all, :conditions => ["classe_id =? and professor_id=? and ano_letivo=? " , @atribuicao.classe_id, @atribuicao.professor_id, Time.now.year])
            respond_to do |format|
                if @atribuicao.update_attributes(params[:atribuicao])
                    @notas = Nota.find(:all, :conditions => ["atribuicao_id = ? AND ano_letivo=?", @atribuicao.id,Time.now.year ])
                    for nota in @notas
                        nota = Nota.find(nota.id)
                        nota.aulas1=@atribuicao.aulas1
                        nota.aulas2=@atribuicao.aulas2
                        nota.aulas3=@atribuicao.aulas3
                        nota.aulas4=@atribuicao.aulas4
                        nota.aulas5=@atribuicao.aulas1 + @atribuicao.aulas2 + @atribuicao.aulas3 + @atribuicao.aulas4
                        nota.save
                    end
                    if  session[:flag_edit]== 1
                        if ((@atribuicao.aulas3 < 1 ) or (@atribuicao.aulas2 < 1 ) or (@atribuicao.aulas1 < 1))
                            format.html { redirect_to(aviso_atribuicaos_path) }
                            format.xml  { head :ok }
                        else
                            flash[:notice] = 'SALVO COM SUCESSO!'
                            format.html { redirect_to(voltar_lancamento_notas_path)}
                        end
                    else
                        if ((@atribuicao.aulas3 < 1 ) or (@atribuicao.aulas2 < 1 ) or (@atribuicao.aulas1 < 1))
                            format.html { redirect_to(aviso_atribuicaos_path) }
                            format.xml  { head :ok }
                        else
                            flash[:notice] = 'SALVO COM SUCESSO!'
                            format.html { redirect_to(@atribuicao) }
                            format.xml  { head :ok }
                        end
                    end
                else
                    format.html { render :action => "edit" }
                    format.xml  { render :xml => @atribuicao.errors, :status => :unprocessable_entity }
                end
            end
        end
        session[:flag_edit_atribuicao]=0
        session[:flag_edit]=0
    end

    def destroy
        @atribuicao = Atribuicao.find(params[:id])
        @atribuicao.destroy
        respond_to do |format|
            format.html { redirect_to(atribuicaos_url) }
            format.xml  { head :ok }
        end
    end


    def consulta_classe_nota
        @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
        for dis in @disci
            disc_id = dis.id
        end
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], disc_id])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], disc_id])
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end

    def lancar_notas
    end

    def lancar_notas_alunos_atribuicaos
        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=? AND notas.ativo=1",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
            @alunos3 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]], :order => 'aluno_nome')
            render :update do |page|
                page.replace_html 'notas', :partial => 'notas'
            end
        end
    end

    def create_notas
        @nota = Nota.new(params[:nota])
        @nota.ano_letivo =  Time.now.year
        @nota.bimestre = 1
        @nota.atribuicao_id= session[:id]
        @nota.professor_id= session[:professor_id]
        @nota.unidade_id= current_user.unidade_id
        session[:aluno_id] = @nota.aluno_id
        @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  session[:classe_id], session[:professor_id], session[:disc_id]])
        if @nota.save
            @nota = Nota.all(:conditions => ["atribuicao_id =? AND aluno_id =?", session[:id], session[:aluno_id]])
            session[:nota_id] = @nota.id
            render :update do |page|
                page.replace_html 'notas_aluno', :partial => "notas"
            end
        end
    end

    def relatorio_aluno_nome
        session[:ano_nota]= Time.now.year
        @aluno = Aluno.find(:all,:conditions =>['id = ?', params[:aluno_aluno_id]])
        session[:aluno] =params[:aluno_aluno_id]
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=? and unidade_id=?', session[:aluno], session[:ano_nota],current_user.unidade_id  ])
        @matriculas.each do |matricula|
            session[:classe]=matricula.classe_id
            session[:num]=matricula.classe_num
            session[:status]=matricula.status
            session[:matricula_id]= matricula.id
        end
        @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
        @classe.each do |classe|
            session[:unidade]=classe.unidade_id
            session[:classe_id] = classe.id
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @matricula = Matricula.find(:all,:conditions =>['classe_id = ? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
        quantidade = @matricula.count
        if quantidade == 1
            session[:matricula_id]= @matricula[0].id
        else if quantidade == 2
                session[:matricula_id]= @matricula[1].id
            else if quantidade == 3
                    session[:matricula_id]= @matricula[2].id
                else if quantidade == 4
                        session[:matricula_id]= @matricula[3].id
                    end
                end
            end
        end
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year, session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year , session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], Time.now.year,nil ] )
        render :partial => 'relatorio_aluno'
    end

    def relatorios_anterior_classe
        if params[:type_of].to_i == 1
            session[:aluno] = params[:aluno][:id]
            session[:ano_nota] = params[:ano_letivo1]
            @aluno = Aluno.find(:all,:conditions =>['id = ? ', session[:aluno]])
            @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=? and unidade_id=?', session[:aluno],session[:ano_nota],current_user.unidade_id  ])
            @matriculas.each do |matricula|
                session[:classe]=matricula.classe_id
                session[:num]=matricula.classe_num
                session[:status]=matricula.status
                session[:matricula_id]= matricula.id
            end
            @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
            @classe.each do |classe|
                session[:unidade]=classe.unidade_id
                session[:classe_id] = classe.id
            end
            @matricula = Matricula.find(:all,:conditions =>['classe_id = ? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
            quantidade = @matricula.count
            if quantidade == 1
                session[:matricula_id]= @matricula[0].id
            else if quantidade == 2
                    session[:matricula_id]= @matricula[1].id
                else if quantidade == 3
                        session[:matricula_id]= @matricula[2].id
                    else if quantidade == 4
                            session[:matricula_id]= @matricula[3].id
                        end
                    end
                end
            end
            @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], current_user.unidade_id, session[:ano_nota], session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], current_user.unidade_id, session[:ano_nota] , session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD
            @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], session[:ano_nota],nil ] )
            render :update do |page|
                page.replace_html 'relatorio', :partial => 'relatorio_aluno'
            end
        else if params[:type_of].to_i == 2
                session[:classe_id] = params[:classe][:id]
                session[:ano_nota] = params[:ano_letivo]
                @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? AND (status = "MATRICULADO" or status = "TRANSFERENCIA" or status = "*REMANEJADO")', params[:classe][:id]], :order =>'classe_num')
                @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
                @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]])
                render :update do |page|
                    page.replace_html 'relatorio', :partial => 'relatorio_classe'
                end
            end
        end
    end

    def relatorio_classe

        if ( params[:disciplina].present?)
            @disci = Disciplina.find(:all, :conditions => ["disciplina =?", params[:disciplina]])
            for dis in @disci
                session[:disc_id] = dis.id
            end
            session[:classe_id] = params[:classe][:id]
            @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @classe.each do |classe|
                session[:num_classe]= classe.classe_classe[0,1].to_i
            end
            @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
            @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]])
        end
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @classes }
        end
    end


    def impressao_relatorio_aluno
        @aluno = Aluno.find(:all,:conditions =>['id = ? ', session[:aluno]])
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=? and unidade_id=?', session[:aluno],session[:ano_nota],current_user.unidade_id ])
        @matriculas.each do |matricula|
            session[:classe]=matricula.classe_id
            session[:num]=matricula.classe_num
            session[:status]=matricula.status
            session[:matricula_id]= matricula.id
        end
        @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
        @classe.each do |classe|
            session[:unidade]=classe.unidade_id
            session[:classe_id] = classe.id
        end
        @matricula = Matricula.find(:all,:conditions =>['classe_id = ? AND aluno_id=?', session[:classe_id], session[:aluno] ], :order =>'classe_num')
        quantidade = @matricula.count
        if quantidade == 1
            session[:matricula_id]= @matricula[0].id
        else if quantidade == 2
                session[:matricula_id]= @matricula[1].id
            else if quantidade == 3
                    session[:matricula_id]= @matricula[2].id
                else if quantidade == 4
                        session[:matricula_id]= @matricula[3].id
                    end
                end
            end
        end
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], current_user.unidade_id, session[:ano_nota], session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL AND matricula_id=?", session[:aluno], current_user.unidade_id, session[:ano_nota] , session[:matricula_id]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @observacao2 = ObservacaoNota.find(:all, :conditions =>['aluno_id =? AND ano_letivo =? AND nota_id is ?', session[:aluno], session[:ano_nota],nil ] )
        render :layout => "impressao"
    end

    #     BOLETIM ESCOLAR   BOLETIM ESCOLAR   BOLETIM ESCOLAR
    def relatorio_aluno_classe
        session[:classe_id] = params[:classe_id]
        session[:ano_nota] = Time.now.year
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ? ', params[:classe_id]], :order =>'classe_num')
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', params[:classe_id]])
        render :partial => 'relatorio_classe'
    end

    def impressao_relatorio_classe
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order =>'classe_num')
        @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ?', session[:classe_id]])
        @alunos = Aluno.find(:all, :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', session[:classe]],:order =>'aluno_nome')
        render :layout => "impressao"
    end


    def relatorio_aluno_professor
        session[:professor_id] = params[:professor_id]
        @professor = Professor.find(:all,:conditions =>['id = ?', params[:professor_id]])
        @classe = Classe.find(:all, :joins => :atribuicaos, :conditions =>['atribuicaos.professor_id = ?', session[:professor_id]])
        @notas = Nota.find(:all, :joins => :atribuicao, :conditions => ["atribuicaos.professor_id =?", session[:professor_id]])
        @alunos = Aluno.find(:all, :joins => :notas, :conditions =>['notas.professor_id =?', session[:professor_id]])
        render :partial => 'relatorio_professor'
    end

    def impressao_relatorio_professor
        @professor = Professor.find(:all,:conditions =>['id = ?', session[:professor_id]])
        @notas = Nota.find(:all, :joins => [:atribuicao,:aluno], :conditions => ["atribuicaos.professor_id =? and  notas.unidade_id =? ", session[:professor_id], current_user.unidade_id],:order => 'alunos.aluno_nome ASC')
        render :layout => "impressao"
    end

    def impressao_lancamentos
        @classe = Classe.find(:all, :joins => "inner join atribuicaos on classes.id = atribuicaos.classe_id", :conditions =>['atribuicaos.classe_id = ? and atribuicaos.professor_id = ? and atribuicaos.disciplina_id =?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
        @atribuicao_classe = Atribuicao.find(:all,:conditions =>['classe_id = ? and professor_id =? and disciplina_id=?', params[:classe][:id], params[:professor][:id], session[:disc_id]])
        @notas = Nota.find(:all, :joins => [:atribuicao, :aluno], :conditions => ["atribuicaos.classe_id =? AND atribuicaos.professor_id =? AND disciplina_id=?",  params[:classe][:id], params[:professor][:id], session[:disc_id]],:order => 'alunos.aluno_nome ASC')
        @alunos3 = Aluno.find(:all, :joins => "INNER JOIN  matriculas  ON  alunos.id=matriculas.aluno_id  INNER JOIN classes ON classes.id=matriculas.classe_id", :conditions =>['classes.id = ?', params[:classe][:id]])
        render :layout => "impressao"
    end

    def relatorio_observacoes
        if ( params[:aluno].present?)
            session[:aluno_imp]= params[:aluno]
            session[:ano_imp]=params[:ano_letivo]
            @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', session[:aluno_imp]])
            session[:aluno] =params[:aluno_aluno_id]
            @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno_imp],params[:ano_letivo]])
            @matriculas.each do |matricula|
                session[:classe]=matricula.classe_id
                session[:num]=matricula.classe_num
            end
            @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
            @classe.each do |classe|
                session[:unidade]=classe.unidade_id
            end
            @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", session[:aluno_imp], current_user.unidade_id, session[:ano_imp]],:order =>'disciplinas.ordem ASC ')
            @notas = @notasB+@notasD
            respond_to do |format|
                format.html # index.html.erb
                format.xml  { render :xml => @notas }
            end
        end
    end


    def mapa_de_classe
        session[:classe_id] = params[:classe][:id]
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  params[:classe][:id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', params[:classe][:id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  params[:classe][:id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?', params[:classe][:id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :update do |page|
            page.replace_html 'mapa', :partial => 'mapa'
        end
    end

    def mapa_de_classe_anterior
        session[:classe_id] = params[:classe_mapa][:id]
        session[:ano] =  params[:ano_letivo_mapa]
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :update do |page|
            page.replace_html 'mapa', :partial => 'mapa'
        end
    end

    def impressao_lencol1
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end

    def impressao_lencol2
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end

    def impressao_lencol3
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end

    def impressao_lencol4
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end
    def impressao_lencol5
        @classe = Classe.find(:all,:conditions =>['id = ?',session[:classe_id]])
        @professor = Professor.find(:all, :joins => [:atribuicaos], :conditions=> ["atribuicaos.classe_id = ? ",  session[:classe_id]], :order => 'nome')
        @atribuicao_classe = Atribuicao.find(:all,:joins => "INNER JOIN classes ON classes.id = atribuicaos.classe_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id",:conditions =>['classe_id = ? AND classes.unidade_id =?', session[:classe_id], current_user.unidade_id],:order =>'disciplinas.ordem ASC')
        @matriculas_classe = Matricula.find(:all,:conditions =>['classe_id = ?',session[:classe_id]], :order => 'classe_num ASC')
        @notas = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id INNER JOIN matriculas ON matriculas.id = notas.matricula_id", :conditions => ["atribuicaos.classe_id =?",  session[:classe_id]],:order =>'matriculas.id ASC')
        @alunos = Aluno.find(:all, :select => 'alunos.id', :joins => "inner join matriculas on alunos.id = matriculas.aluno_id", :conditions =>['matriculas.classe_id =?',session[:classe_id]],:order =>' matriculas.classe_num')
        @disciplinas= Disciplina.find(:all)
        render :layout => "impressao"
    end

    def historico_aluno
        @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno_nome
        end
        @historico_aluno = Aluno.find(session[:aluno_id])
        @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
        @disciplinas = Disciplina.find(:all, :conditions =>['id < 22'],:order => 'ordem ASC' )
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        render :update do |page|
            page.replace_html 'historico', :partial => 'notas_historico'
        end

    end

    def arquivo_historico
        @aluno = Aluno.find(:all, :conditions => ['id =?',session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @unidade = Unidade.find(:all, :conditions => ['id =?', session[:unidade_id]])
        @disciplinas = Disciplina.find(:all, :conditions =>['id < 22'],:order => 'ordem ASC' )
        @matricula = Matricula.find(:last, :conditions => ['aluno_id = ? AND unidade_id = ?', session[:aluno_id],session[:unidade_id]] )
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        respond_to do |format|
            format.xls
        end
    end


    def impressao_historico
        @aluno = Aluno.find(:all, :conditions => ['id =?', session[:aluno_id]])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , session[:aluno_id], Time.now.year])
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id,Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_id], Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        render :layout => "impressao"
    end


    def download_historico
        send_file("#{RAILS_ROOT}/public/saidas/#{current_user.unidade.nome}_#{session[:aluno_nome]}_#{Date.today.strftime("%Y_%m_%d")}.xls")
    end


    def transferenciaA
  
    end

    def transferencia_aluno
        session[:aluno_id]=params[:aluno][:aluno_id]
        @aluno = Matricula.find(:all, :conditions => ['aluno_id =? and unidade_id =? and ano_letivo=?', params[:aluno][:aluno_id],current_user.unidade_id, Time.now.year])
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
            session[:aluno_nome] = aluno.aluno.aluno_nome
        end
        @matricula= Matricula.find(:all, :conditions =>["aluno_id=? AND ano_letivo=? AND unidade_id=?",params[:aluno][:aluno_id], Time.now.year,  current_user.unidade_id])
        for matricula in @matricula
            session[:classe]= matricula.classe.classe_classe
            session[:unidade_user]= matricula.classe.unidade_id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
        @classe.each do |classe|
            session[:num_classe]= classe.classe_classe[0,1].to_i
        end
        @historico_aluno = ObservacaoHistorico.find(:all, :conditions => ['aluno_id=?', session[:aluno_id]])
        @unidade = Unidade.find(:all, :select => 'nome',:conditions => ['id =?', session[:unidade_id]])
        @notasDisciplinasD= Nota.find(:all, :select =>'notas.id',:joins => [:disciplina], :conditions=> ['aluno_id=? AND notas.ano_letivo <?', session[:aluno_id] , Time.now.year], :order => 'notas.ano_letivo ASC')
        @disciplinasB = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina, disciplinas.curriculo FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'B' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @disciplinasD = Disciplina.find_by_sql("SELECT DISTINCT (disciplinas.id), disciplinas.disciplina, disciplinas.curriculo FROM `disciplinas` INNER JOIN notas ON disciplinas.id = notas.disciplina_id WHERE (disciplinas.curriculo = 'D' AND notas.aluno_id ="+session[:aluno_id].to_s+" )")
        @notasB = Nota.find_by_sql("SELECT notas.*, di.disciplina,  di.curriculo FROM `notas` LEFT JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'B' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' or notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        @notasD = Nota.find_by_sql("SELECT notas.*, di.disciplina, di.curriculo FROM `notas` LEFT JOIN disciplinas di ON di.id = notas.disciplina_id LEFT JOIN matriculas ma ON ma.id = notas.matricula_id WHERE notas.aluno_id = "+session[:aluno_id].to_s+" AND di.curriculo = 'D' AND (ma.status='MATRICULADO' OR ma.status='TRANSFERENCIA' OR ma.status='*REMANEJADO' OR notas.matricula_id is NULL) ORDER BY notas.disciplina_id, notas.ano_letivo")
        session[:contnotaBTot]=(@notasB.count)
        session[:contnotaDTot]=(@notasD.count)
        @disciplinas = @disciplinasD + @disciplinasB
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], session[:unidade_user],Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',params[:aluno][:aluno_id]], :order => 'ano_letivo ASC')
        ano = @ano_inicial.ano_letivo
        classeano = @ano_inicial.classe
        classe = @ano_inicial.matricula.classe.classe_classe[0,1].to_i
        @ano_final = Nota.find(:last, :conditions => ['aluno_id =?',params[:aluno][:aluno_id]], :order => 'ano_letivo ASC')
        render :update do |page|
            page.replace_html 'transferencia', :partial => 'transferencia'
        end
    end

    def impressao_transferencia_aluno
        @aluno = Matricula.find(:all, :conditions => ['aluno_id =? and unidade_id =? and ano_letivo=?', session[:aluno_id],current_user.unidade_id, Time.now.year])
        for matricula in @aluno
            session[:classe]= matricula.classe.classe_classe
            session[:unidade_user]= matricula.classe.unidade_id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , session[:aluno_id], Time.now.year])
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' AND notas.ano_letivo =? AND notas.unidade_id =?", session[:aluno_id], Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notasB1 = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =?", session[:aluno_id], session[:unidade_user], Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.unidade_id =?"  ,session[:aluno_id],session[:unidade_user],Time.now.year, session[:unidade_user]],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        @notas_ano = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["disciplinas.id=1 AND notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =?",  session[:aluno_id], current_user.unidade_id,Time.now.year],:order =>'disciplinas.ordem ASC ')
        @ano_inicial = Nota.find(:first, :conditions => ['aluno_id =?',session[:aluno_id]], :order => 'ano_letivo ASC')
        render :layout => "impressao"
    end


    def reserva_vaga
        @aluno = Aluno.find(:all, :conditions => ['id =?', params[:aluno][:aluno_id]])
        session[:aluno_id]=params[:aluno][:aluno_id]
        for aluno in @aluno
            session[:unidade_id]= aluno.unidade_id
            session[:aluno_id]= aluno.id
        end
        @classe = Classe.find(:all, :joins => "inner join matriculas on classes.id = matriculas.classe_id", :conditions =>['matriculas.aluno_id =? AND ano_letivo=?' , params[:aluno][:aluno_id], Time.now.year])
        render :update do |page|
            page.replace_html 'documento', :partial => 'reserva_vaga'
        end
    end

    def consulta_observacoes
        render  'relatorios_observacoes'
  
    end

    def consulta_atribuicao
        @classe = Classe.find(:all, :select => 'distinct(classe_classe)', :joins => "INNER JOIN  matriculas  ON  classes.id = matriculas.classe_id" , :conditions =>['classes.unidade_id =? AND matriculas.ano_letivo=?' , current_user.unidade_id, Time.now.year],:order =>'classe_classe ASC ')
    end

    def editar_atribuicao_classe
        session[:classe_id]=params[:atribuicao][:classe_id]
        @classe = Classe.find(:all,:conditions =>['id = ?', params[:atribuicao][:classe_id]])
        @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:atribuicao][:classe_id],0], :order =>'disciplinas.ordem ASC ' )
        @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:atribuicao][:classe_id]], :order => 'classe_num ASC')
        render :update do |page|
            page.replace_html 'classe_alunos', :partial => 'alunos_classe'
        end
    end

    def observacoes_aluno
        @aluno = Aluno.find(:all,:conditions =>['id = ? AND aluno_status is null', params[:aluno_aluno_id]])
        session[:aluno] =params[:aluno_aluno_id]
        @matriculas = Matricula.find(:all,:conditions =>['aluno_id = ? and  ano_letivo=?', session[:aluno],Time.now.year ])
        @matriculas.each do |matricula|
            session[:classe]=matricula.classe_id
            session[:num]=matricula.classe_num
        end
        @classe= Classe.find(:all,:conditions =>['id = ?', session[:classe]])
        @classe.each do |classe|
            session[:unidade]=classe.unidade_id
        end
        @notasB = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'B' and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year],:order =>'disciplinas.ordem ASC ')
        @notasD = Nota.find(:all, :joins => "INNER JOIN atribuicaos ON atribuicaos.id = notas.atribuicao_id INNER JOIN disciplinas ON disciplinas.id = atribuicaos.disciplina_id", :conditions => ["notas.aluno_id =?  AND disciplinas.curriculo = 'D'and unidade_id =? AND notas.ano_letivo =? AND notas.ativo is NULL ", params[:aluno_aluno_id], current_user.unidade_id, Time.now.year   ],:order =>'disciplinas.ordem ASC ')
        @notas = @notasB+@notasD
        render :partial => 'observacoes_aluno'
    end


    def load_professores11
        @professores1 = type_user(current_user.unidade_id)
    end

    def load_professores1
        if  (current_user.unidade_id == 53) or (current_user.unidade_id == 52) or (current_user.unidade_id == 100)
            @professores1 = Professore.find(:all, :conditions =>  ["desligado=0"], :order => 'nome ASC')
        else
            if unit == 99
                @professores1 = Professore.find(:all, :conditions =>  ["desligado=0 and unidade_id is ?", nil], :order => 'nome ASC')
            else
                @professores1 = Professore.find(:all, :conditions =>  ["desligado=0= 0 and unidade_id = ?", unit], :order => 'nome ASC')
            end
        end
    end

    def classes_ano
        @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )
        render :partial => 'selecao_classe'
    end

    def mapa_classe_ano
        @classe_ano = Classe.find(:all, :conditions=> ['classe_ano_letivo =? and unidade_id=?' , params[:ano_letivo], current_user.unidade_id]    )
        render :partial => 'selecao_mapa'
    end
  

    def load_classes
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @classes = Classe.find(:all, :conditions => ['classe_ano_letivo = ?', Time.now.year], :order => 'classe_classe ASC')
            if current_user.professor_id.nil?
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id < 26 or id > 27"])
                end

            else
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id != 27 and id !=26"])
                end
            end
        else
            @classes = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ?', current_user.unidade_id, Time.now.year], :order => 'classe_classe ASC')
            if current_user.professor_id.nil?
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id < 26 or id > 27"])
                end

            else
                if (current_user.unidade_id < 42 or current_user.unidade_id > 53) and current_user.unidade_id != 62
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id = 26 or id = 27"])
                else
                    @disciplinas1 = Disciplina.find(:all, :conditions => ["id != 27 and id !=26"])
                end
            end
        end
    end

    def load_professors
        if current_user.unidade_id == 53 or current_user.unidade_id == 52
            @professors = Professor.find(:all, :select => "id, nome", :conditions => 'desligado = 0',:order => 'nome ASC')
        else
            @professors = Professor.find(:all,:select => "id, nome", :conditions => ['id = ? AND desligado = 0', current_user.professor_id  ],:order => 'nome ASC')
        end
    end

end
