class MmanutencaosController < ApplicationController
  


 def index

    if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')or current_user.has_role?('estagiario SEDUC')
        @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <>2 ORDER BY mma.data_sol DESC")
    else
      if current_user.has_role?('diretor_unidade')
         @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and mma.unidade_id ="+(current_user.unidade_id).to_s+" ORDER BY mma.data_sol DESC")
      else if current_user.has_role?('terceiro')
        @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <>2 and (chefia_id = 12 or chefia_id = 13) ORDER BY mma.data_sol DESC")
          else
            #   @mmanutencaos_abertas = Mmanutencao.all(:conditions => ["situacao_manutencao_id <> 2"])
                @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and mma.unidade_id ="+(current_user.unidade_id).to_s+" ORDER BY mma.data_sol DESC")
          end
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mmanutencaos }
    end
  end

 def estatistica
    if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao')
       @mmanutencaos = Mmanutencao.all(:conditions =>  "situacao_manutencao_id <> 2")
       @mmanutencaos_todos= Mmanutencao.all
    else
      if current_user.has_role?('diretor_unidade')
       @mmanutencaos = Mmanutencao.all(:conditions =>["situacao_manutencao_id <> 2 and unidade_id = ?",current_user.unidade_id ])
      else
       @mmanutencaos = Mmanutencao.all(:conditions =>["situacao_manutencao_id <> 2 and user_id = ?",current_user])
       $chefia1=@mmanutencaos.user_id.current_user
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mmanutencaos }
    end
  end

def relatorios
end





def consulta_encerrados_unidade
     if params[:type_of].to_i == 1
        tipo=  params[:manutencao][:tipo]
        t=0
        @mmanutencaos = Mmanutencao.find_by_sql("SELECT mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id WHERE (situacao_manutencao_id = 2 or situacao_manutencao_id = 9) and tma.tipos_manutencao_id ="+tipo.to_s+" order by data_enc DESC ")
          render :update do |page|
                  page.replace_html 'encerrados', :partial => "encerrados"
             end
     else if params[:type_of].to_i == 2
             unidade=params[:unidade][:id]
             @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id = 2 or situacao_manutencao_id = 9) and unidade_id ="+unidade.to_s+" order by data_enc DESC ")
                 render :update do |page|
                      page.replace_html 'encerrados', :partial => "encerrados"
                 end
          else if params[:type_of].to_i == 3
                        if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('terceiro')or current_user.has_role?('oficios')or current_user.has_role?('estagiario SEDUC')or current_user.has_role?('SEDUC')
                            @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id = 2 or situacao_manutencao_id = 9)")
                        else
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id = 2 or situacao_manutencao_id = 9) and unidade_id ="+(current_user.unidade_id).to_s+" order by data_enc DESC ")
                        end
                     render :update do |page|
                         page.replace_html 'encerrados', :partial => "encerrados"
                     end
              else if params[:type_of].to_i == 4
                        # NÂO UTILIUZADO
                     else if params[:type_of].to_i == 5
                        # NÂO UTILIUZADO
                     end
                  end
              end
          end
     end





end

def consultas_encerrados
     if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao')or current_user.has_role?('SEDUC')
      @unidades_manutencao =  Unidade.find(:all, :order => 'nome ASC')
     else
        if (current_user.unidade_id== 53)
           @unidades_manutencao =  Unidade.find(:all, :order => 'nome ASC')
        else
          @unidades_manutencao =  Unidade.find(:all, :conditions => ['id = ?',current_user.unidade_id ],:order => 'nome ASC')
        end
    end
     @servicos =  TiposManutencao.find(:all, :order => 'servico ASC')
end



def consulta_abertos_unidade
     if params[:type_of].to_i == 1
         session[:type_of] = 1
        session[:tipo]=  params[:manutencao][:tipo]
        @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and tma.tipos_manutencao_id ="+session[:tipo].to_s+" order by data_sol DESC ")
      
          render :update do |page|
                  page.replace_html 'abertos', :partial => "abertos"
             end
     else if params[:type_of].to_i == 2
             session[:type_of] = 2
             session[:unidade]=params[:unidade][:id]
                if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')or current_user.has_role?('estagiario SEDUC') or current_user.has_role?('SEDUC')
                  #  @mmanutencaos_abertas = Mmanutencao.all(:conditions => ["situacao_manutencao_id <> 2"])
                     #@mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma RIGHT JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <>2 ORDER BY mma.data_sol DESC")
                     @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9)   and mma.unidade_id ="+session[:unidade].to_s+" ORDER BY mma.data_sol DESC")

                else
                  if current_user.has_role?('diretor_unidade')
                      @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) and mma.unidade_id ="+session[:unidade].to_s+" ORDER BY mma.data_sol DESC")
                  else if current_user.has_role?('terceiro')
                          @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) and (chefia_id = 12 or chefia_id = 13) ORDER BY mma.data_sol DESC")
                      else
                            @mmanutencaos_unidade = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) and mma.unidade_id ="+(unidade).to_s+" ORDER BY mma.data_sol DESC")
                      end
                  end
                end
            
                 render :update do |page|
                      page.replace_html 'abertos', :partial => "abertos"
                 end
          else if params[:type_of].to_i == 3  # ANTIGO TODOS   ATUAL POR PALAVRA
                  session[:type_of] = 3
                        if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('terceiro')or current_user.has_role?('oficios')or current_user.has_role?('estagiario SEDUC') or current_user.has_role?('SEDUC')
                            #@mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id = 2")
                            @mmanutencaos = Mmanutencao.find(:all, :select =>'(unidades.nome) AS nome, mmanutencaos.id, mmanutencaos.unidade_id,  mmanutencaos.situacao_manutencao_id, mmanutencaos.funcionario_id, mmanutencaos.ffuncionario, mmanutencaos.chefia_id, mmanutencaos.user_id, mmanutencaos.descricao, mmanutencaos.data_sol, mmanutencaos.data_ate, mmanutencaos.data_enc, mmanutencaos.forma, mmanutencaos.solicitante, mmanutencaos.procedimentos, mmanutencaos.executado, mmanutencaos.justificativa, mmanutencaos.obs',:joins=> 'INNER JOIN '+session[:base]+'.unidades ON unidades.id = mmanutencaos.unidade_id', :conditions => ["mmanutencaos.descricao like ?", "%" + params[:palavra].to_s + "%"],:order => 'mmanutencaos.data_sol DESC' )
#                            @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma RIGHT JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE   (mma.nome like "+%" "+ params[:palavra].to_s"  "+%") AND  (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) ORDER BY mma.data_sol DESC")
#                                      @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma RIGHT JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE   (mma.nome like "+%" "+ params[:palavra].to_s"  "+%") AND  (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) ORDER BY mma.data_sol DESC")
 #                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma RIGHT JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) ORDER BY mma.data_sol DESC")
#                            @professors = Professor.find(:all,:conditions => ["nome like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
                        else
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (situacao_manutencao_id <> 2 AND situacao_manutencao_id <> 9) and unidade_id ="+(current_user.unidade_id).to_s+" order by data_sol DESC ")
#                            @professors = Professor.find(:all,:conditions => ["nome like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
                        end

                     render :update do |page|
                         page.replace_html 'abertos', :partial => "abertos"
                     end
              else if params[:type_of].to_i == 4
                        w=session[:sstatus]=  params[:manutencao][:situacao_manutencao_id]
                        session[:type_of] = 4
                        if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')or current_user.has_role?('estagiario SEDUC') or current_user.has_role?('SEDUC')
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE  mma.situacao_manutencao_id ="+(session[:sstatus]).to_s+"   ORDER BY mma.data_sol DESC")
                        else
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE mma.unidade_id ="+(current_user.unidade_id).to_s+"  and mma.situacao_manutencao_id ="+(session[:sstatus]).to_s+"   ORDER BY mma.data_sol DESC")
                        end
                       render :update do |page|
                         page.replace_html 'abertos', :partial => "abertos"
                       end

                     else if params[:type_of].to_i == 5
                          session[:type_of] = 5
                             session[:dataI]=params[:mmanutencao][:inicio][6,4]+'-'+params[:mmanutencao][:inicio][3,2]+'-'+params[:mmanutencao][:inicio][0,2]
                             session[:dataF]=params[:mmanutencao][:fim][6,4]+'-'+params[:mmanutencao][:fim][3,2]+'-'+params[:mmanutencao][:fim][0,2]
                             session[:mes]=params[:mmanutencao][:fim][3,2]
                             session[:anoI]=params[:mmanutencao][:inicio][6,4]
                             session[:anoF]=params[:mmanutencao][:fim][6,4]
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
                                     @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"')   ORDER BY mma.data_sol DESC")
                                             render :update do |page|
                                               page.replace_html 'abertos', :partial => "abertos"
                                             end
                     end
                  end
              end
          end
     end





end

def consultas_abertos
     @situacao_manutencao =  SituacaoManutencao.find(:all, :conditions =>  ["id <> 2"], :order => 'situacao')
                        
     if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao')or current_user.has_role?('SEDUC')
      @unidades_manutencao =  Unidade.find(:all, :order => 'nome ASC')
     else
        if (current_user.unidade_id== 53)
           @unidades_manutencao =  Unidade.find(:all, :order => 'nome ASC')
        else 
          @unidades_manutencao =  Unidade.find(:all, :conditions => ['id = ?',current_user.unidade_id ],:order => 'nome ASC')
        end
    end
     @servicos =  TiposManutencao.find(:all, :order => 'servico ASC')
end


 def relatorios_manutencaos
   session[:dataI]=params[:manutecao][:dataI][6,4]+'-'+params[:manutecao][:dataI][3,2]+'-'+params[:manutecao][:dataI][0,2]
   session[:dataF]=params[:manutecao][:dataF][6,4]+'-'+params[:manutecao][:dataF][3,2]+'-'+params[:manutecao][:dataF][0,2]
   session[:dataI2]=params[:manutecao][:dataI][0,2]+'/'+ params[:manutecao][:dataI][3,2]+'/'+params[:manutecao][:dataI][6,4]
   session[:dataF2]=params[:manutecao][:dataF][0,2]+'/'+ params[:manutecao][:dataF][3,2]+'/'+params[:manutecao][:dataF][6,4]

   w=session[:manutencaotipos_manutencao_id]=params[:manutencao][:tipos_manutencao_id]
     if !session[:manutencaotipos_manutencao_id].empty?
         @servico= TiposManutencao.find(:all, :conditions=> ['id =?',  params[:manutencao][:tipos_manutencao_id]] )
        w= session[:servico]= @servico[0].servico
    @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  tma.tipos_manutencao_id ="+params[:manutencao][:tipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDER BY  mma.data_sol DESC")
    @situacaos = Mmanutencao.find_by_sql("SELECT mma.situacao_manutencao_id, sm.situacao, count( mma.id ) AS contador FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id JOIN situacao_manutencaos sm ON sm.id = mma.situacao_manutencao_id WHERE tma.tipos_manutencao_id ="+params[:manutencao][:tipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' GROUP BY mma.situacao_manutencao_id ORDER BY  mma.data_sol DESC")
     @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  tma.tipos_manutencao_id ="+params[:manutencao][:tipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDER BY  mma.data_sol DESC")
     else
     t=0
      @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDEr BY  mma.data_sol DESC")
      @situacaos = Mmanutencao.find_by_sql("SELECT mma.situacao_manutencao_id, sm.situacao, count( mma.id ) AS contador FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id JOIN situacao_manutencaos sm ON sm.id = mma.situacao_manutencao_id WHERE mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' GROUP BY mma.situacao_manutencao_id ORDER BY  mma.data_sol DESC")
       session[:servico]= 'TODOS'
   end

     render :update do |page|
            page.replace_html 'relatorio', :partial => 'relatorio'
     end
 end


 def estatisticasM
   session[:nome_manutencao1]= 'em '+(Date.today.strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 1 and created_at > ?", $data])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and created_at > ?", $data])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and created_at > ?", $data])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and created_at > ?", $data])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and created_at > ?", $data])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and created_at > ?", $data])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and created_at > ?", $data])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and created_at > ?", $data])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and created_at > ?", $data])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and created_at > ?", $data])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and created_at > ?", $data])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and created_at > ?", $data])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and created_at > ?", $data])
                                                                      session[:nome_manutencao]= "PODA DE GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and created_at > ?", $data])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
 end


 def estatisticasMA
   session[:nome_manutencao1]= 'EM ABERTO em '+(Date.today.strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id=1 and situacao_manutencao_id=1 and created_at > ?", $data])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and situacao_manutencao_id=1 and created_at > ?", $data])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and situacao_manutencao_id=1 and created_at > ?", $data])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and situacao_manutencao_id=1 and created_at > ?", $data])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and situacao_manutencao_id=1 and created_at > ?", $data])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and situacao_manutencao_id=1 and created_at > ?", $data])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and situacao_manutencao_id=1 and created_at > ?", $data])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and situacao_manutencao_id=1 and created_at > ?", $data])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and situacao_manutencao_id=1 and created_at > ?", $data])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and situacao_manutencao_id=1 and created_at > ?", $data])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and situacao_manutencao_id=1 and created_at > ?", $data])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and situacao_manutencao_id=1 and created_at > ?", $data])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and situacao_manutencao_id=1 and created_at > ?", $data])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and situacao_manutencao_id=1 and created_at > ?", $data])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else
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
        end
   end
  end

 def estatisticasME
   session[:nome_manutencao1]= 'ENCERRADO em '+(Date.today.strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id=1 and situacao_manutencao_id=2 and created_at > ?", $data])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and situacao_manutencao_id=2 and created_at > ?", $data])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and situacao_manutencao_id=2 and created_at > ?", $data])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and situacao_manutencao_id=2 and created_at > ?", $data])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and situacao_manutencao_id=2 and created_at > ?", $data])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and situacao_manutencao_id=2 and created_at > ?", $data])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and situacao_manutencao_id=2 and created_at > ?", $data])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and situacao_manutencao_id=2 and created_at > ?", $data])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and situacao_manutencao_id=2 and created_at > ?", $data])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and situacao_manutencao_id=2 and created_at > ?", $data])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and situacao_manutencao_id=2 and created_at > ?", $data])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and situacao_manutencao_id=2 and created_at > ?", $data])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and situacao_manutencao_id=2 and created_at > ?", $data])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and situacao_manutencao_id=2 and created_at > ?", $data])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else
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
        end
   end
 
 end

 def estatisticasMAt
   session[:nome_manutencao1]= 'EM ATENDIMENTO em '+(Date.today.strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id=1 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ?", $data])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            
                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
 end


 def estatisticasMANT
   session[:nome_manutencao1]= 'em '+((Date.today<<1).strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 1 and created_at > ? and created_at < ?", $datai, $dataf])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and created_at > ? and created_at < ?", $datai, $dataf])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and created_at > ? and created_at < ?", $datai, $dataf])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and created_at > ? and created_at < ?", $datai, $dataf])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and created_at > ? and created_at < ?", $datai, $dataf])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and created_at > ? and created_at < ?", $datai, $dataf])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and created_at > ? and created_at < ?", $datai, $dataf])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and created_at > ? and created_at < ?", $datai, $dataf])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and created_at > ? and created_at < ?", $datai, $dataf])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and created_at > ? and created_at < ?", $datai, $dataf])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and created_at > ? and created_at < ?", $datai, $dataf])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                      session[:nome_manutencao]= "PODA DE GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
 end


 def estatisticasMANTA
   session[:nome_manutencao1]= 'EM ABERTO em '+((Date.today<<1).strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 1 and situacao_manutencao_id = 1 and created_at > ? and created_at < ?", $datai, $dataf])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and situacao_manutencao_id=1 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
  end


 def estatisticasMANTE
    session[:nome_manutencao1]= 'ENCERRADO em '+((Date.today<<1).strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id=1 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and situacao_manutencao_id=2 and created_at > ? and created_at < ?", $datai, $dataf])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"

                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
 end


def estatisticasMANTAt
   session[:nome_manutencao1]= 'EM ATENDIMENTO em '+((Date.today<<1).strftime("%B"))
   if (params[:estatisticas].to_i == 1)
      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id=1 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
      session[:nome_manutencao]= 'ALVENARIA'
      render "estatisticasM"
   else if (params[:estatisticas].to_i == 2)
           @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
           session[:nome_manutencao]= 'DEDETIZAÇÃO'
           render "estatisticasM"
        else if (params[:estatisticas].to_i == 3)
              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
              session[:nome_manutencao]= 'ELETRODOMÉSTICOS'
              render "estatisticasM"
             else if (params[:estatisticas].to_i == 4)
                   @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                   session[:nome_manutencao]= 'ELÉTRICA'
                   render "estatisticasM"
                  else if (params[:estatisticas].to_i == 5)
                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                        session[:nome_manutencao]= 'MATERIAL DE COZINHA'
                        render "estatisticasM"
                       else if (params[:estatisticas].to_i == 6)
                             @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                             session[:nome_manutencao]= 'HIDRÁULICA'
                             render "estatisticasM"
                            else if (params[:estatisticas].to_i == 7)
                                  @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                  session[:nome_manutencao]= 'MARCENARIA'
                                  render "estatisticasM"
                                  else if (params[:estatisticas].to_i == 8)
                                        @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                        session[:nome_manutencao]= 'PINTURA'
                                        render "estatisticasM"
                                        else if (params[:estatisticas].to_i == 9)
                                              @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                              session[:nome_manutencao]= "LIMPEZA CAIXA D'AGUA"
                                              render "estatisticasM"
                                              else if (params[:estatisticas].to_i == 10)
                                                    @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                                    session[:nome_manutencao]= "PLAYGROUND"
                                                    render "estatisticasM"
                                                    else if (params[:estatisticas].to_i == 11)
                                                          @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                                          session[:nome_manutencao]= "SERRALHERIA"
                                                          render "estatisticasM"
                                                          else if (params[:estatisticas].to_i == 12)
                                                                @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                                                session[:nome_manutencao]= "TELHADO"
                                                                render "estatisticasM"
                                                                else if (params[:estatisticas].to_i == 13)
                                                                      @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                                                      session[:nome_manutencao]= "PODA GRAMA"
                                                                      render "estatisticasM"
                                                                      else if (params[:estatisticas].to_i == 14)
                                                                            @mmanutencaos_estatisticas = Mmanutencao.all(:joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id', :conditions => ["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 and (situacao_manutencao_id=3 OR situacao_manutencao_id=4) and created_at > ? and created_at < ?", $datai, $dataf])
                                                                            session[:nome_manutencao]= "OUTROS SERVIÇOS"
                                                                            render "estatisticasM"
                                                                            else

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
        end
   end
 end


  def show
    @mmanutencao = Mmanutencao.find(params[:id])
    session[:id_manutencao]=params[:id]
    session[:idprotocolo]= @mmanutencao.id
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mmanutencao }
    end
  end

  def new
    @mmanutencao = Mmanutencao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mmanutencao }
    end
  end

  def edit
    @mmanutencao = Mmanutencao.find(params[:id])
  end

  def create
    @mmanutencao = Mmanutencao.new(params[:mmanutencao])


    @mmanutencao.data_sol= Time.now
    @mmanutencao.user_id = current_user.id
    respond_to do |format|
      if @mmanutencao.save
        flash[:notice] = 'MANUTENÇÃO SOLICITADA.'
        format.html { redirect_to(@mmanutencao) }
        format.xml  { render :xml => @mmanutencao, :status => :created, :location => @mmanutencao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mmanutencao.errors, :status => :unprocessable_entity }
      end
    end
  end

  def impressao_chamado_manutencao
      @mmanutencao = Mmanutencao.find(params[:id])
      sesssion[:idprotocolo] = @mmanutencao.id
    render :layout => "impressao"
  end


  def update
    @mmanutencao = Mmanutencao.find(params[:id])
   respond_to do |format|
      if @mmanutencao.update_attributes(params[:mmanutencao])
       if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')

          @mmanutencao.situacao = 'PARA ORÇAMENTO'
           if @mmanutencao.situacao_manutencao_id == 8
                 @mmanutencao.situacao = 'AUTORIZADO'
                @mmanutencao.chefia_id= 13
                @mmanutencao.data_autoriza = Time.now
                t=0
           end
       else
         @mmanutencao.situacao = nil
       end
     if session[:despacho]==1
         @mmanutencao.data_ate = Time.now
       session[:despacho]=0
     end


    
     @mmanutencao.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@mmanutencao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mmanutencao.errors, :status => :unprocessable_entity }
      end
       t=0
    end
  end

  def destroy
    @mmanutencao = Mmanutencao.find(params[:id])
    @mmanutencao.destroy
    respond_to do |format|
      format.html { redirect_to(mmanutencaos_url) }
      format.xml  { head :ok }
    end
  end

def consulta
   render 'consultas'
  end

def lista_manutencao
    $chefia = params[:manutencao_chefia_id]
    @mmanutencaos   = Mmanutencao.find(:all, :conditions => ['chefia_id= ? and situacao_manutencao_id != 2', $chefia ])
    render :partial => 'lista_manutencao'
  end


def lista_unidade
    @mmanutencaos   = Mmanutencao.find(:all, :conditions => ['unidade_id= ? and situacao_manutencao_id != 2', params[:unidade_unidade_id] ])
    render :partial => 'lista_manutencao'
  end


  def despacho
    @mmanutencao = Mmanutencao.find(params[:id])
    @mmanutencao.data_ate = Time.now
  end


 def terceirizada
    @mmanutencao = Mmanutencao.find(params[:id])
    
  end

 def ordemservico
    @mmanutencao = Mmanutencao.find(params[:id])
 end

 def selected_print
   @mmanutencaos = Mmanutencao.find(params[:chamado_ids])
 end

 def impressao_manutencao
   @mmanutencao = Mmanutencao.find(params[:id])
   $idmanutencao= @mmanutencao.id

 end

  def impressao_estatistica_unidade_aberta 
      
     
        if session[:type_of].to_i == 1
         @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and tma.tipos_manutencao_id ="+session[:tipo].to_s+" order by data_sol DESC ")
           render :layout => "impressao"
     else if session[:type_of].to_i == 2
            t=0
                if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')or current_user.has_role?('estagiario SEDUC')
                     @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id,  mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and mma.unidade_id ="+session[:unidade].to_s+" ORDER BY mma.data_sol DESC")
                      t=0
                else
                  if current_user.has_role?('diretor_unidade')
                      @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and mma.unidade_id ="+session[:unidade].to_s+" ORDER BY mma.data_sol DESC")
                  else if current_user.has_role?('terceiro')
                          @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <>2 and (chefia_id = 12 or chefia_id = 13) ORDER BY mma.data_sol DESC")
                      else
                            @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and mma.unidade_id ="+(unidade).to_s+" ORDER BY mma.data_sol DESC")
                      end
                  end
                end

                 render :layout => "impressao"
          else if session[:type_of].to_i == 3
                        if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('terceiro')or current_user.has_role?('oficios')or current_user.has_role?('estagiario SEDUC')
                            #@mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id = 2")
                            @mmanutencao = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma RIGHT JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <>2 ORDER BY mma.data_sol DESC")
                        else
                           @mmanutencao = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id <> 2 and unidade_id ="+(current_user.unidade_id).to_s+" order by data_sol DESC ")
                        end
 t=0
                    render :layout => "impressao"
              else if session[:type_of].to_i == 4
                        w=session[:sstatus]=  params[:manutencao][:situacao_manutencao_id]

                        if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('SEDUC')or current_user.has_role?('estagiario SEDUC') or current_user.has_role?('SEDUC')
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE  mma.situacao_manutencao_id ="+(session[:sstatus]).to_s+"   ORDER BY mma.data_sol DESC")
                        else
                           @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE mma.unidade_id ="+(current_user.unidade_id).to_s+"  and mma.situacao_manutencao_id ="+(session[:sstatus]).to_s+"   ORDER BY mma.data_sol DESC")
                        end
                         render :layout => "impressao"
                     else if session[:type_of].to_i == 5


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
                              t=0
                                     @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE (data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"')   ORDER BY mma.data_sol DESC")
                                     t=0
                                             render :layout => "impressao"
                     end
                  end
              end
          end
     end


t=0
 end


 def impressao_relatorio
     if !session[:manutencaotipos_manutencao_id].empty?
         session[:servico]=  TiposManutencao.find_by_id(session[:manutencaotipos_manutencao_id]).servico

        #@servico= TiposManutencao.find(:all, :conditions=> ['id =?',  session[:manutencaotipos_manutencao_id]] )
        #session[:servico]= @servico[0].servico
        @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  tma.tipos_manutencao_id ="+session[:manutencaotipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDER BY  mma.data_sol DESC")
        @situacaos = Mmanutencao.find_by_sql("SELECT mma.situacao_manutencao_id, sm.situacao, count( mma.id ) AS contador FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id JOIN situacao_manutencaos sm ON sm.id = mma.situacao_manutencao_id WHERE tma.tipos_manutencao_id ="+session[:manutencaotipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' GROUP BY mma.situacao_manutencao_id ORDER BY  mma.data_sol DESC")
        @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  tma.tipos_manutencao_id ="+session[:manutencaotipos_manutencao_id]+" AND mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDEr BY  mma.data_sol DESC")
     else
      @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome AS nome, mma.id, mma.unidade_id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id =  mma.id WHERE  mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' ORDEr BY  mma.data_sol DESC")
      @situacaos = Mmanutencao.find_by_sql("SELECT mma.situacao_manutencao_id, sm.situacao, count( mma.id ) AS contador FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id  INNER JOIN mmanutencaos_tipos_manutencaos tma ON tma.mmanutencao_id = mma.id JOIN situacao_manutencaos sm ON sm.id = mma.situacao_manutencao_id WHERE mma.data_sol BETWEEN '"+session[:dataI]+"' AND '"+session[:dataF]+"' GROUP BY mma.situacao_manutencao_id ORDER BY  mma.data_sol DESC")
       session[:servico]= 'TODOS'
   end
   render :layout => "impressao"
 end




 def protocolo
    @mmanutencao = Mmanutencao.find(params[:id])
    sesssion[:idprotocolo] = @mmanutencao.id
    @mmanutencao= Mmanutencao.find(sesssion[:idprotocolo])
   render :layout => "protocolo"
  end


 def imp_manutencao
    @mmanutencao= Mmanutencao.find(session[:idmanutencao])
   render :layout => "impressao"
  end

 def imp_show
    @mmanutencao= Mmanutencao.find(session[:idmanutencao])
   render :layout => "impressao"
  end

   def encerrados
    if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao') or current_user.has_role?('terceiro')or current_user.has_role?('oficios')or current_user.has_role?('estagiario SEDUC')
      #@mmanutencaos =Mmanutencao.all(:conditions =>["situacao_manutencao_id = 2" ], :order => 'data_enc DESC')
        @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id = 2")
    else
       @mmanutencaos = Mmanutencao.find_by_sql("SELECT uni.nome as nome, mma.id, mma.unidade_id, mma.situacao_manutencao_id, mma.funcionario_id, mma.ffuncionario, mma.chefia_id, mma.user_id, mma.descricao, mma.data_sol, mma.data_ate, mma.data_enc, mma.forma, mma.solicitante, mma.procedimentos, mma.executado, mma.justificativa, mma.obs  FROM mmanutencaos mma INNER JOIN "+session[:base]+".unidades uni ON uni.id = mma.unidade_id WHERE situacao_manutencao_id = 2 and unidade_id ="+(current_user.unidade_id).to_s+" order by data_enc DESC ")
      # @mmanutencaos =Mmanutencao.all(:conditions =>["situacao_manutencao_id = 2 and unidade_id = ?",current_user.unidade_id ], :order => 'data_enc DESC')
    end
   
  end

 def showencerrado
     @mmanutencao = Mmanutencao.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @mmanutencao }
    end
 end

 def busca_protocolo
$ok=1
    if (params[:search].present?)
      if current_user.has_role?('admin') or current_user.has_role?('admin_manutencao')
        @mmanutencao = Mmanutencao.find(:all, :conditions => ["id = ?",  params[:search]])
        $ok=0
     else
        if current_user.has_role?('diretor_unidade')
           @mmanutencao = Mmanutencao.find(:all, :conditions => ["id = ? and unidade_id=?",  params[:search], current_user.unidade_id])
           $ok=0
        else
           @mmanutencao = Mmanutencao.find(:all, :conditions => ["id = ?",  params[:search]])
           $ok=0
       end
     end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mmanutencao }
    end
  end



end
