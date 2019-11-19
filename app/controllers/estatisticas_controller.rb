class EstatisticasController < ApplicationController
  before_filter :load_unidades
  def index

  end


def estatistica
end

  def grafico_demanda_geral
    @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

        @static_graph = Gchart.pie_3d(
          :data => [(Crianca.matriculada).length,(Crianca.na_demanda).length, (Crianca.cancelada).length],
          :title => "Demanda Geral - Crianças Cadastradas: #{Crianca.total_demanda.length}",
          :size => '600x300',
          :format => 'image_tag',
          :labels => ["Matriculadas: #{(Crianca.matriculada).length}", "Demanda: #{(Crianca.na_demanda).length}" , "Canceladas: #{(Crianca.cancelada).length}",])
  end  

  def impressao_geral


    if  session[:geral] == 0
      @graph = open_flash_chart_object(600,300,"/grafico/graph_code_demanda_geral")

          @static_graph = Gchart.pie_3d(
            :data => [(Crianca.matriculada).length,(Crianca.na_demanda).length, (Crianca.cancelada).length],
            :title => "Demanda Geral - Crianças Cadastradas: #{Crianca.total_demanda.length}",
            :size => '700x350',
            :format => 'image_tag',
            :labels => ["Matriculadas: #{(Crianca.matriculada).length}", "Demanda: #{(Crianca.na_demanda).length}" , "Canceladas: #{(Crianca.cancelada).length}",])
    else

      @static_graph = Gchart.pie_3d(
            :data => [(Crianca.matriculas_crianca_por_unidade(session[:input])).length,(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length, (Crianca.cancelada_crianca_por_unidade(session[:input])).length],
            :title => "Demanda por Unidade: #{Crianca.nome_unidade(session[:input])} - #{(Crianca.todas_crianca_por_unidade(session[:input])).length}" ,
            :size => '700x350',
            :format => 'image_tag',
            :labels => ["Matriculadas: #{(Crianca.matriculas_crianca_por_unidade(session[:input])).length}", "Demanda: #{(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length}", "Canceladas: #{(Crianca.cancelada_crianca_por_unidade(session[:input])).length}"])

    end
      render :layout => "impressao"

end

    def impressao_estatistica_unidade

t=0


#    if  session[:geral] == 0
    vencerrado=(Mmanutencao.aberto_unidade(session[:input])).length
    vaberto =  (Mmanutencao.encerrado_unidade(session[:input])).length
    vtotal= Mmanutencao.geral.length
    pe = (vencerrado.to_f/vtotal.to_f)*100
    pa = (vaberto.to_f/vtotal.to_f)*100
    pr = (vtotal.to_f-vencerrado.to_f-vaberto.to_f)/vtotal.to_f * 100

        valvenaria = (Mmanutencao.alvernaria_aberto_unidade(session[:input])).length
        vdedetizacao = (Mmanutencao.dedetizacao_aberto_unidade(session[:input])).length
        veletrodomesticos = (Mmanutencao.eletro_aberto_unidade(session[:input])).length
        veletrica = (Mmanutencao.eletri_aberto_unidade(session[:input])).length
        vequipamento_cozinha = (Mmanutencao.cozinha_aberto_unidade(session[:input])).length
        vhidraulica = (Mmanutencao.hidrau_aberto_unidade(session[:input])).length
        vlimpeza = (Mmanutencao.limpeza_aberto_unidade(session[:input])).length
        vmarcenaria = (Mmanutencao.marcenaria_aberto_unidade(session[:input])).length
        vpintura = (Mmanutencao.pintura_aberto_unidade(session[:input])).length
        vplayground = (Mmanutencao.playground_aberto_unidade(session[:input])).length
        vpoda_grama = (Mmanutencao.aberto_unidade(session[:input])).length
        vserralheria = (Mmanutencao.serallheria_aberto_unidade(session[:input])).length
        vtelhado = (Mmanutencao.telhado_aberto_unidade(session[:input])).length
        voutros = (Mmanutencao.outros_aberto_unidade(session[:input])).length


        palvenaria = (valvenaria.to_f / vaberto)*100
        pdedetizacao = (vdedetizacao.to_f / vaberto)*100
        peletrodomesticos =(veletrodomesticos.to_f / vaberto)*100
        peletrica= (veletrica.to_f / vaberto)*100
        pequipamento_cozinha= (vequipamento_cozinha / vaberto)*100 
        phidraulica=(vhidraulica.to_f / vaberto)*100
        plimpeza=(vlimpeza.to_f / vaberto)*100 
        pmarcenaria=(vmarcenaria.to_f / vaberto)*100 
        ppintura=(vpintura.to_f / vaberto)*100 
        pplayground=(vplayground.to_f / vaberto)*100 
        ppoda_grama=(vpoda_grama.to_f / vaberto)*100 
        pserralheria=(vserralheria.to_f / vaberto)*100
        ptelhado=(vtelhado.to_f / vaberto)*100 
        poutros=(voutros.to_f / vaberto)*100



   @static_graph = Gchart.pie_3d(
        :data => [vaberto,vencerrado, (vtotal-vencerrado-vaberto)/3],
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{(Mmanutencao.por_unidade(session[:input]) ).length} chamados de um total de #{vtotal} " ,
        :size => '600x300',
        :format => 'image_tag',
        :labels => ["Abertas:  #{vaberto} ", "Encerradas:  #{vencerrado}", "Outras: #{(vtotal-vencerrado-vaberto)}",])


   @static_graph2 = Gchart.pie_3d(
        :data => [vaberto,vencerrado],
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{(Mmanutencao.por_unidade(session[:input])).length} chamados" ,
        :size => '900x450',
        :format => 'image_tag',
        :labels => ["Abertas:  #{vaberto}", "Encerradas:  #{vencerrado}", ])



@static_graph3 = Gchart.pie_3d(
        :data => [ valvenaria, vdedetizacao, veletrodomesticos, veletrica, vequipamento_cozinha, vhidraulica, vlimpeza,  vmarcenaria,  vpintura, vplayground, vpoda_grama, vserralheria, vtelhado, voutros],               
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{(Mmanutencao.por_unidade(session[:input])).length} Serviços" ,
        :size => '1000x500',
        :format => 'image_tag',
        :labels => ["Alvenaria:  #{valvenaria}", "Dedetização:  #{vdedetizacao}", "Eletrodomésticos:  #{veletrodomesticos}","Elétrica:  #{veletrica}", "Equip.Cozinha:  #{vequipamento_cozinha}", "Hidráulica:  #{vhidraulica}","Limp.Cx.Água:  #{vlimpeza}", "Marcenaria:  #{ vmarcenaria}", "Pintura:  #{ vpintura}","Playground:  #{vplayground}", "Poda grama:  #{vpoda_grama}","Serralheria:  #{vserralheria}","Telhado:  #{ vtelhado}","Outros:  #{voutros}",])

        
    
 #    else

#      @static_graph = Gchart.pie_3d(
#            :data => [(Crianca.matriculas_crianca_por_unidade(session[:input])).length,(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length, (Crianca.cancelada_crianca_por_unidade(session[:input])).length],
#            :title => "Demanda por Unidade: #{Crianca.nome_unidade(session[:input])} - #{(Crianca.todas_crianca_por_unidade(session[:input])).length}" ,
#            :size => '700x350',
#            :format => 'image_tag',
#            :labels => ["Matriculadas: #{(Crianca.matriculas_crianca_por_unidade(session[:input])).length}", "Demanda: #{(Crianca.nao_matriculas_crianca_por_unidade(session[:input])).length}", "Canceladas: #{(Crianca.cancelada_crianca_por_unidade(session[:input])).length}"])

#    end
      render :layout => "impressao"

end

  def grafico_demanda_unidade

  end

  def por_unidade
    $menu=1
    session[:input] = params[:contact][:grafico_id]
    @graph = open_flash_chart_object(600,300,"/estatistica/grafico_por_unidade?unidade=#{session[:input]}",false,'/')

        vencerrado=(Mmanutencao.encerrado_unidade(session[:input])).length
        vaberto =  (Mmanutencao.aberto_unidade(session[:input])).length
        vtotal= Mmanutencao.geral.length
        valvenaria = (Mmanutencao.alvenaria_aberto_unidade(session[:input])).length
        vdedetizacao = (Mmanutencao.dedetizacao_aberto_unidade(session[:input])).length
        veletrodomesticos = (Mmanutencao.eletro_aberto_unidade(session[:input])).length
        veletrica = (Mmanutencao.eletrica_aberto_unidade(session[:input])).length
        vequipamento_cozinha = (Mmanutencao.cozinha_aberto_unidade(session[:input])).length
        vhidraulica = (Mmanutencao.hidrau_aberto_unidade(session[:input])).length
        vlimpeza = (Mmanutencao.limpeza_aberto_unidade(session[:input])).length
        vmarcenaria = (Mmanutencao.marcenaria_aberto_unidade(session[:input])).length
        vpintura = (Mmanutencao.pintura_aberto_unidade(session[:input])).length
        vplayground = (Mmanutencao.playground_aberto_unidade(session[:input])).length
        vpoda_grama = (Mmanutencao.grama_aberto_unidade(session[:input])).length
        vserralheria = (Mmanutencao.serralheria_aberto_unidade(session[:input])).length
        vtelhado = (Mmanutencao.telhado_aberto_unidade(session[:input])).length
        voutros = (Mmanutencao.outros_aberto_unidade(session[:input])).length
    pe = ((vencerrado.to_f/vtotal.to_f)*100).round(2)
    pa = ((vaberto.to_f/vtotal.to_f)*100).round(2)
    pr = (vtotal.to_f-vencerrado.to_f-vaberto.to_f)/vtotal.to_f * 100

      
    @static_graph = Gchart.pie(
        :data => [vaberto,vencerrado, (vtotal-vencerrado-vaberto)/2],
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{(Mmanutencao.por_unidade(session[:input])).length} chamados de um total de #{vtotal} - (#{(((Mmanutencao.por_unidade(session[:input])).length).to_f/(vtotal).to_f*100).round(2)})% " ,
        :size => '700x400',
        :format => 'image_tag',
        :labels => ["Abertas: #{vaberto}  (#{((vaberto.to_f)/(vtotal).to_f * 100).round(2)} %)",
                     "Encerrados.:#{vencerrado}  (#{((vencerrado.to_f)/(vtotal).to_f * 100).round(2)} %)",
                     "Outras Unidades: #{(vtotal-vencerrado-vaberto)}",])
        

   @static_graph2 = Gchart.pie(
        :data => [vaberto,vencerrado],
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{(Mmanutencao.por_unidade(session[:input])).length} chamados - (#{(((Mmanutencao.por_unidade(session[:input])).length).to_f/(vtotal).to_f*100).round(2)})% " ,
        :size => '700x400',
        :format => 'image_tag',
        :labels => ["Abertas: #{vaberto} - (#{((vaberto.to_f)/((Mmanutencao.por_unidade(session[:input])).length).to_f * 100).round(2)}) % ",
                    "Encerrados.: #{vencerrado} - (#{((vencerrado.to_f)/((Mmanutencao.por_unidade(session[:input])).length).to_f * 100).round(2)}) % ", ])

    @static_graph3 = Gchart.pie(
        :data => [ valvenaria,
                   vdedetizacao,
                   veletrodomesticos,
                   veletrica,
                   vequipamento_cozinha,
                   vhidraulica,
                   vlimpeza,
                   vmarcenaria,
                   vpintura,
                   vplayground,
                   vpoda_grama,
                   vserralheria,
                   vtelhado,
                   voutros],
        :title => "Unidade: #{Mmanutencao.nome_unidade(session[:input])} - #{vaberto} Serviços em Aberto"  ,
        :size => '700x400',
        :format => 'image_tag',
        :labels => ["Alvenaria: #{valvenaria}  (#{((valvenaria.to_f)/(vaberto).to_f * 100).round(2)} %)", 
                   "Dedetização: #{vdedetizacao}  (#{((vdedetizacao.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Eletrodomestico: #{veletrodomesticos}  (#{((veletrodomesticos.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Elétrica: #{veletrica}  (#{((veletrica.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Equip.Cozinha.: #{vequipamento_cozinha}  (#{((vequipamento_cozinha.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Hidráulica: #{vhidraulica}  (#{((vhidraulica.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Limpeza Cx.Água: #{vlimpeza}  (#{((vlimpeza.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Marcenaria: #{ vmarcenaria}  (#{((vmarcenaria.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Pintura: #{ vpintura}  (#{((vpintura.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Playground: #{vplayground}  (#{((vplayground.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Poda Grama: #{vpoda_grama}  (#{((vpoda_grama.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Serralheria:  #{vserralheria}  (#{((vserralheria.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Telhado: #{ vtelhado}  (#{((vtelhado.to_f)/(vaberto).to_f * 100).round(2)} %)",
                   "Outros: #{voutros}  (#{((voutros.to_f)/(vaberto).to_f * 100).round(2)} %)", ])


      render :action => "estatistica_unidade"
  end


   def por_servico
    $menu=1
    session[:input] = params[:contact][:grafico_id]
         vencerrado= (Mmanutencao.encerrado_servico(session[:input])).length
         vaberto = (Mmanutencao.aberto_servico(session[:input])).length
         vtotal= Mmanutencao.geral.length
        quant_unidade = Unidade.all(:conditions =>['desativada = 0']).count

       
        valvenaria = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 1 ", session[:input] ]).size
        vdedetizacao =Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3 ", session[:input] ]).size
        veletrodomesticos = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4 ", session[:input] ]).size
        veletrica = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5", session[:input] ]).size
        vequipamento_cozinha = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6 ", session[:input] ]).size
        vhidraulica = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7 ", session[:input] ]).size
        vlimpeza = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8 ", session[:input] ]).size
        vmarcenaria = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9 ", session[:input] ]).size
        vpintura = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10", session[:input] ]).size
        vplayground = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11", session[:input] ]).size
        vpoda_grama = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12", session[:input] ]).size
        vserralheria = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13", session[:input] ]).size
        vtelhado = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14", session[:input] ]).size
        voutros = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15", session[:input] ]).size

        valvenaria_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 1  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vdedetizacao_ab =Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        veletrodomesticos_ab = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        veletrica_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vequipamento_cozinha_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vhidraulica_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vlimpeza_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vmarcenaria_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9  AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vpintura_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vplayground_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vpoda_grama_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vserralheria_ab = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        vtelhado_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size
        voutros_ab = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 AND mmanutencaos.situacao_manutencao_id = 2", session[:input] ]).size

        valvenaria_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 1  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vdedetizacao_en =Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 3  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        veletrodomesticos_en = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 4  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        veletrica_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 5 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vequipamento_cozinha_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 6  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vhidraulica_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 7  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vlimpeza_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 8  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vmarcenaria_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 9  AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vpintura_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 10 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vplayground_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 11 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vpoda_grama_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 12 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vserralheria_en = Mmanutencao.find(:all, :joins =>'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 13 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        vtelhado_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 14 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size
        voutros_en = Mmanutencao.find(:all, :joins => 'INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id',  :conditions =>["mmanutencaos_tipos_manutencaos.tipos_manutencao_id= 15 AND mmanutencaos.situacao_manutencao_id <> 2", session[:input] ]).size


        pe = (vencerrado.to_f/vtotal.to_f)*100
        pa = (vaberto.to_f/vtotal.to_f)*100
        pr = (vtotal.to_f-vencerrado.to_f-vaberto.to_f)/vtotal.to_f * 100
        #ptotal = (vtotal / (Mmanutencao.por_servico(session[:input]) ).length).to_f * 100
        ptotal = (((Mmanutencao.por_servico(session[:input]) ).length).to_f/(vtotal.to_f) *100).round(2)
    @graph = open_flash_chart_object(800,350,"/estatistica/grafico_por_servico?servico=#{session[:input]}",false,'/')
    @static_graph4 = Gchart.pie(
        :data => [vaberto,vencerrado, (vtotal-vencerrado-vaberto)/2],
        :title => "Serviço: #{Mmanutencao.servico(session[:input])}  - #{(Mmanutencao.por_servico(session[:input]) ).length} serviços de um total de #{vtotal} (#{ptotal}%) " ,
        :size => '800x350',
        :format => 'image_tag',
        :labels => ["Aberto: #{vaberto} (#{((vaberto.to_f)/((vtotal).to_f) * 100).round(2)} %)", "Encerrado: #{vencerrado} (#{((vencerrado.to_f)/((vtotal).to_f) * 100).round(2)} %)", "Outros: #{(vtotal-vencerrado-vaberto)}  (#{((vtotal-vencerrado-vaberto.to_f)/((vtotal).to_f) * 100).round(2)} %)",])


   @static_graph5 = Gchart.pie(
        :data => [vaberto,vencerrado],
        :title => "Serviço: #{Mmanutencao.servico(session[:input])} - #{(Mmanutencao.por_servico(session[:input])).length} chamados  (#{(((Mmanutencao.por_servico(session[:input]).length).to_f)/((vtotal).to_f) * 100).round(2)} %)" ,
        :size => '800x350',
        :format => 'image_tag',
        :labels => ["Aberto: #{vaberto}  (#{((vaberto.to_f)/((Mmanutencao.por_servico(session[:input]).length).to_f) * 100).round(2)} %)", "Encerrado: #{vencerrado} (#{((vencerrado.to_f)/((Mmanutencao.por_servico(session[:input]).length).to_f) * 100).round(2)} %)", ])

    @static_graph3 = Gchart.pie(
        :data => [valvenaria, vdedetizacao, veletrodomesticos, veletrica, vequipamento_cozinha, vhidraulica, vlimpeza,  vmarcenaria,  vpintura, vplayground, vpoda_grama, vserralheria, vtelhado, voutros
                 ],
        :title =>  "Total de Serviços: #{vtotal} NA SEDUC  (Abertos: #{Mmanutencao.aberto_geral.size} -  Encerrados:#{Mmanutencao.encerrado_geral.size})"  ,
        :size => '800x350',
        :format => 'image_tag',
        :labels => ["Alvenaria: #{valvenaria}  (#{((valvenaria.to_f)/(vtotal.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Dedetização.: #{vdedetizacao}  (#{((vdedetizacao.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Eletrodoméstico.: #{veletrodomesticos}  (#{((veletrodomesticos.to_f) /(vtotal.to_f)* 100).round(2)} %)",
                    "Elétrica: #{veletrica}  (#{((veletrica.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Equip.Cozinha: #{vequipamento_cozinha}  (#{((vequipamento_cozinha.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Hidráulica.: #{vhidraulica}  (#{((vhidraulica.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Limpeza Cx.Água: #{vlimpeza}  (#{((vlimpeza.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Marcenaria: #{ vmarcenaria}  (#{((vmarcenaria.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Pintura: #{ vpintura}  (#{((vpintura.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Playground: #{vplayground}  (#{((vplayground.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Poda Grama: #{vpoda_grama}  (#{((vpoda_grama.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Serralheria:  #{vserralheria}  (#{((vserralheria.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Telhado: #{ vtelhado}  (#{((vtelhado.to_f)/(vtotal.to_f) * 100).round(2)} %)",
                    "Outros: #{voutros}  (#{((voutros.to_f)/(vtotal.to_f) * 100).round(2)} %)", ])

    @static_graph6 = Gchart.pie(
        :data => [valvenaria_ab, vdedetizacao_ab, veletrodomesticos_ab, veletrica_ab, vequipamento_cozinha_ab, vhidraulica_ab, vlimpeza_ab,  vmarcenaria_ab,  vpintura_ab, vplayground_ab, vpoda_grama_ab, vserralheria_ab, vtelhado_ab, voutros_ab
                 ],
        :title =>  "Serviços EM ABERTOS  na SEDUC : #{Mmanutencao.aberto_geral.size}  de  #{Mmanutencao.encerrado_geral.size + Mmanutencao.aberto_geral.size } serviços"  ,
        :size => '800x350',
        :format => 'image_tag',
        :labels => ["Alvenaria: #{valvenaria_ab}  (#{((valvenaria_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Dedetização.: #{vdedetizacao_ab}  (#{((vdedetizacao_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Eletrodoméstico.: #{veletrodomesticos_ab}  (#{((veletrodomesticos_ab.to_f) /((Mmanutencao.aberto_geral.size).to_f)* 100).round(2)} %)",
                    "Elétrica: #{veletrica_ab}  (#{((veletrica_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Equip.Cozinha: #{vequipamento_cozinha_ab}  (#{((vequipamento_cozinha_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Hidráulica.: #{vhidraulica_ab}  (#{((vhidraulica_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Limpeza Cx.Água: #{vlimpeza_ab}  (#{((vlimpeza_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Marcenaria: #{ vmarcenaria_ab}  (#{((vmarcenaria_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Pintura: #{ vpintura_ab}  (#{((vpintura_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Playground: #{vplayground_ab}  (#{((vplayground_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Poda Grama: #{vpoda_grama_ab}  (#{((vpoda_grama_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Serralheria:  #{vserralheria_ab}  (#{((vserralheria_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Telhado: #{ vtelhado_ab}  (#{((vtelhado_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)",
                    "Outros: #{voutros_ab}  (#{((voutros_ab.to_f)/((Mmanutencao.aberto_geral.size).to_f) * 100).round(2)} %)", ])

    @static_graph7 = Gchart.pie(
        :data => [valvenaria_en, vdedetizacao_en, veletrodomesticos_en, veletrica_en, vequipamento_cozinha_en, vhidraulica_en, vlimpeza_en,  vmarcenaria_en,  vpintura_en, vplayground_en, vpoda_grama_en, vserralheria_en, vtelhado_en, voutros_en
                 ],
        :title =>  "Serviços ENCERRADOS na SEDUC: #{Mmanutencao.encerrado_geral.size}  de  #{Mmanutencao.encerrado_geral.size + Mmanutencao.aberto_geral.size } serviços"  ,
        :size => '800x350',
        :format => 'image_tag',
        :labels => ["Alvenaria: #{valvenaria_en}  (#{((valvenaria_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Dedetização.: #{vdedetizacao_en}  (#{((vdedetizacao_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Eletrodoméstico.: #{veletrodomesticos_en}  (#{((veletrodomesticos_en.to_f) /((Mmanutencao.encerrado_geral.size).to_f)* 100).round(2)} %)",
                    "Elétrica: #{veletrica_en}  (#{((veletrica_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Equip.Cozinha: #{vequipamento_cozinha_en}  (#{((vequipamento_cozinha_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Hidráulica.: #{vhidraulica_en}  (#{((vhidraulica_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Limpeza Cx.Água: #{vlimpeza_en}  (#{((vlimpeza_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Marcenaria: #{ vmarcenaria_en}  (#{((vmarcenaria_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Pintura: #{ vpintura_en}  (#{((vpintura_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Playground: #{vplayground_en}  (#{((vplayground_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Poda Grama: #{vpoda_grama_en}  (#{((vpoda_grama_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Serralheria:  #{vserralheria_en}  (#{((vserralheria_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Telhado: #{ vtelhado_en}  (#{((vtelhado_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)",
                    "Outros: #{voutros_en}  (#{((voutros_en.to_f)/((Mmanutencao.encerrado_geral.size).to_f) * 100).round(2)} %)", ])



      render :action => "estatistica_servico"
  end



  def graph_code_demanda_geral
    title = Title.new("Demanda Geral - Crianças Cadastradas: #{Crianca.total_demanda.length}")
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    pie.values  = [PieValue.new(Crianca.matriculada.length,"Crianças Matriculadas"),
                   PieValue.new(Crianca.matriculada.length,"Crianças Não Matriculadas"),
                   PieValue.new(Crianca.cacnelada.length,"Inscrição Cancelada")
                   ]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end

  def estatistica_unidade

  end


  def grafico_unidade    #graph_por_unidade
    unidade = params[:unidade]
    title = Title.new("Manutenção Unidade: #{Mmanutencao.nome_unidade(unidade)} - Solicitações: #{Mmanutencao.por_unidade(unidade).length}" )
    pie = Pie.new
    pie.start_angle = 0
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    abertos = Mmanuntencao.aberto_unidade(unidade)
    encerrados = Mmanuntencao.encerrado_unidade(unidade)
    pie.values  = [PieValue.new(aberto_geral.length,"Solicitações ABERTAS na unidade: " + (aberto_geral.length).to_s), PieValue.new(encerrado_geral.length,"Crianças Não Matriculadas: " + (nao_matriculada.length).to_s)]
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)
    chart.x_axis = nil
    render :text => chart.to_s
  end


  def pie_chart poll
    @pie_chart ||= {
      :data => poll.choices.collect(&:votes_count),
      :colors => poll.choices.collect {|c| c.winner? ? "264409" : "8A1F11" }
    }
  end


protected

  def load_unidades
       @unidades = Unidade.find(:all, :order => 'nome ASC')
       @servicos = TiposManutencao.find(:all, :order => 'servico ASC')
  
    $uni=1
    $menu=0
  end
end
