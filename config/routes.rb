ActionController::Routing::Routes.draw do |map|
  map.resources :orc_reservas,:collection => {:consulta => :get}
  map.resources :orc_ata_itens
  map.resources :orc_atas,:collection => {:consulta => :get,:consulta_ata => :get}
  map.resources :orc_nota_fiscals, :collection => {:consulta => :get,  :nf_selecionados => :get}
  map.resources :orc_nota_fiscal_itens
  map.resources :orc_lancamentos, :collection => {:consulta => :get, :consultaSI => :get}
  map.resources :orc_pagamentos, :collection => {:consulta => :get}
  map.resources :orc_suplementacaos, :collection => {:consulta => :get}
  map.resources :orc_empenho_itens
  map.resources :orc_empenhos, :collection => {:consulta => :get, :consulta_produto => :get    }
  map.resources :orc_pedido_descricaos
  map.resources :orc_pedido_compras, :collection => {:consulta => :get, :si_selecionados => :get}
  map.resources :orc_fichas, :collection => {:consulta => :get, :saldo => :get}
  map.resources :orc_uni_orcamentarias, :collection => {:consulta => :get}
  map.resources :orc_uni_despesas
  map.resources :poda_gramas, :collection => {:agenda => :get,:agendamento => :get, :agenda_execucao => :get,:agenda_executada => :get, :agenda_nexecutada => :get, :relatorio_agendamento => :get}
  map.resources :certificados, :collection => {:aviso => :get, :unidades => :get, :infantil => :get, :fundamental => :get, :apoio => :get}

  map.resources :acompanhamento_despachos

  map.resources :acompanhamentos, :collection => {:acompanhamento=>:get, :consulta => :get, :editar => :get}

  map.resources :despachos
  map.resources :produtos
  map.resources :produtos_lancamentos
  map.resources :agendas
  map.resources :reservar_salas, :collection => {:confirma_agenda => :get}
  map.resources :reservar_salas_servicos_salas
  map.resources :servicos_salas
  map.resources :inscricaos, :collection => {:listagem => :get, :listagem_participantes => :get,:checar => :get,:confirmacao => :get,:envia_email => :get,:estatistica => :get, :voltarinscricao => :get, :tipo_opcao => :get, :consultas => :get,:por_curso => :get, :aviso => :get}
  map.resources :cursos, :collection => {:voltar => :get, :consulta => :get}
  map.resources :participantes, :collection => {:busca_por_turno => :get,:consulta => :get,:voltarparticipante => :get, :aviso => :get}, :member => [:addemail,:update_email]
  map.resources :senhas
  map.resources :chamados, :collection => {:selected_print => :get, :busca_protocolo => :get}
  map.resources :aulas_faltas, :collection => { :aviso => :get, :relatorio_falta_dia=>:get, :relatorio_falta_mes=>:get, :show=>:get, :index2=>:get , :index3=>:get, :index4=>:get ,   :relatorio_falta_mes_professor => :get , :relatorio_falta_mes_funcionario => :get}
  map.resources :servicos_internos, :collection => {:consulta => :get, :consultaint=>:get}
  map.resources :mmanutencaos,  :collection => {:protocolo => :get, :consultas => :get, :selected_print => :get,:imprimir_manutencao => :get,:imp_manutencao => :get,:imp_show => :get ,:encerrados => :get, :busca_protocolo => :get , :estatistica => :get, :estatisticasM => :get, :estatisticasMA => :get, :estatisticasME => :get, :estatisticasMAt => :get, :estatisticasMANT => :get, :estatisticasMANTA => :get, :estatisticasMANTE => :get, :estatisticasMANTAt => :get, :consulta_unidade => :get , :relatorios => :get }
  map.resources :mmanutencaos_tipos_manutencaos
  map.resources :justificativas
  map.resources :pontos
  map.resources :estagiarios, :collection => {:periodo_unidade => :get, :periodo_estagio => :get, :periodo_trabalho => :get, :print_all => :get, :carga_horaria => :get, :rel_ponto => :get, :consultas => :get}
  #map.resources :estagiarios, :collection => {:consultas => :get, :show =>:get}
  #map.resources :aulas_faltas, :collection => {:relatorio_falta_mes=>:get, :index2=>:get , :index3=>:get,  :relatorio_falta_mes_professor => :get , :relatorio_falta_mes_funcionario => :get }
  map.resources :funcionarios, :collection => {:consultas => :get }
  map.resources :aulas_eventuals, :collection => { :index2=>:get,   :relatorio_eventual_mes_professor => :get,  :relatorio_eventual_mes_unidade => :get}
  map.resources :eventuals , :collection => { :aviso => :get}
  map.resources :ufaltas
  map.resources :matriculas,:collection => { :transferencia=>:get, :alterar=>:get, :saidas=>:get, :consultar => :get, :new1 => :get, :remanejamento=>:get, :aviso=>:get, :aviso1=>:get, :aviso2=>:get}
  map.resources :disciplinas
  map.resources :atribuicaos, :collection => { :consulta_classe=>:get, :relatorios_classe=>:get, :relatorios_anterior_classe=>:get, :lancar_notas => :get, :relatorio_classe => :get, :mapa_classe => :get, :mapa_classe_anterior => :get,:consulta_professor_classe=>:get, :historico_aluno=>:get, :historico => :get, :transferencia_aluno => :get, :transferenciaA=> :get,  :reserva_vaga=> :get,  :reserva_vagas=> :get,  :relatorio_observacoes=> :get, :editar_atribuicao=>:get, :aviso=>:get}
  map.resources :classes_professors
  map.resources :classes,:collection => { :editar_classe=>:get, :gerar_notas=>:get, :nucleo_basico =>:get, :consulta_classe_fone =>:get}
  map.resources :professors,:collection => { :consulta_classe=>:get,  :consulta_classe_anterior=>:get }
  map.resources :tipos
  map.resources :unidades,  :collection => {:consultas => :get}
  map.resources :logs
  map.resources :roles_users
  map.resources :users, :collection => {:aviso => :get}
  map.resources :classes
  map.resources :informativos
  map.resources :logs
  map.resource :session, :informatica => :get,  :collection => {:aviso_1 => :get}
  map.resources :graficos
  map.resources :oficios, :collection => {:consulta => :get, :consultaof=>:get, :oficios => :get,}

  map.oficio 'oficio', :controller => 'sessions', :action => 'oficio'
  map.manutencao 'manutencao', :controller => 'sessions', :action => 'manutencao'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "home"
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.informatica 'informatica', :controller => 'sessions', :action => 'informatica'
  map.aviso_password '/aviso_password', :controller => 'sessions', :action => 'aviso'


  map.new_itens '/new_itens', :controller => 'orc_empenhos', :action => 'new_itens'
  map.new_descricaos'/new_descricaos', :controller => 'orc_pedido_compras', :action => 'new_descricaos'



  map.saldo_dotacao'/saldo_dotacao', :controller => 'orc_fichas', :action => 'saldo_dotacao'
  map.lista_produto_periodo_index '/lista_produto_periodo_index', :controller => 'produtos_lancamentos', :action => 'lista_produto_periodo_index'
  map.lista_produto_entrada_index '/lista_produto_entrada_index', :controller => 'produtos_lancamentos', :action => 'lista_produto_entrada_index'
  map.lista_produto_saida_index '/lista_produto_saida_index', :controller => 'produtos_lancamentos', :action => 'lista_produto_saida_index'
  map.index_periodo '/index_periodo', :controller => 'produtos_lancamentos', :action => 'index_periodo'
  map.index_entrada '/index_entrada', :controller => 'produtos_lancamentos', :action => 'index_entrada'
  map.index_saida '/index_saida', :controller => 'produtos_lancamentos', :action => 'index_saida'
  map.new_entrada '/new_entrada', :controller => 'produtos_lancamentos', :action => 'new_entrada'
  map.new_saida '/new_saida', :controller => 'produtos_lancamentos', :action => 'new_saida'
  map.lista_inscricaos '/lista_inscricaos', :controller => 'inscricaos', :action => 'lista_inscricaos'
  map.encerrados '/cencerrados', :controller => 'chamados', :action => 'encerrados'
  map.estatisticas '/estatisticas', :controller => 'estatisticas', :action => 'estatiticas'
  map.estatistica_unidade '/estatistica_unidade', :controller => 'estatisticas', :action => 'estatistica_unidade'
  map.impressao_estatistica_unidade '/impressao_estatistica_unidade', :controller => 'estatisticas', :action => 'impressao_estatistica_unidade'
  map.impressao_estatistica_unidade_aberta '/impressao_estatistica_unidade_aberta', :controller => 'mmanutencaos', :action => 'impressao_estatistica_unidade_aberta'
  map.impressao_relatorio '/impressao_relatorio', :controller => 'mmanutencaos', :action => 'impressao_relatorio'

  map.estatistica_servico '/estatistica_servico', :controller => 'estatisticas', :action => 'estatistica_servico'

  map.consultas_encerrados '/consultas_encerrados', :controller => 'mmanutencaos', :action => 'consultas_encerrados'
  map.consulta_encerrados_unidade '/consulta_encerrados_unidade', :controller => 'mmanutencaos', :action => 'consulta_encerrados_unidade'
  map.consultas_abertos '/consultas_abertos', :controller => 'mmanutencaos', :action => 'consultas_abertos'
  map.consulta_abertos_unidade '/consulta_abertos_unidade', :controller => 'mmanutencaos', :action => 'consulta_abertos_unidade'


  map.sem_estagiario '/sem_estagiario', :controller => 'unidades', :action => 'sem_estagiarios'
  map.aulas_eventuals2 '/aulas_eventuals2', :controller => 'aulas_eventuals', :action => 'index2'
  map.aulas_faltas2 '/aulas_faltas2', :controller => 'aulas_faltas', :action => 'index2'
  map.aulas_faltas3 '/aulas_faltas3', :controller => 'aulas_faltas', :action => 'index3'
  map.aulas_faltas4 '/aulas_faltas4', :controller => 'aulas_faltas', :action => 'index4'
  map.montar_classe '/montar_classe', :controller => 'classes', :action => 'montar_classe'
  map.new_disciplinanota '/new_disciplinanota', :controller => 'disciplinas', :action => 'new_disciplinanota'
  map.create_discipina_nota '/create_discipina_nota', :controller => 'disciplinas', :action => 'create_discipina_nota'

    map.impressao_nf'/impressao_nf', :controller => 'orc_nota_fiscals', :action => 'impressao_nf'
  map.impressao_dotacao'/impressao_dotacao', :controller => 'orc_fichas', :action => 'impressao_dotacao'
  map.impressao_sem_empenho'/impressao_sem_empenho', :controller => 'orc_pedido_compras', :action => 'impressao_sem_empenho'
  map.impressao_atendimento '/impressao_atendimento', :controller => 'chamados', :action => 'impressao_atendimento'
  map.impressao_geral '/grafico/impressao_geral', :controller => 'grafico', :action => 'impressao_geral'
  map.impressao_estagiarios_unidade '/impressao_estagiarios_unidade', :controller => 'unidades', :action => 'impressao_estagiarios_unidade'
  map.impressao_classe '/impressao_classe', :controller => 'classes', :action => 'impressao_classe'
  map.impressao_classe_fone '/impressao_classe_fone', :controller => 'classes', :action => 'impressao_classe_fone'
  map.impressao_piloto '/impressao_piloto', :controller => 'classes', :action => 'impressao_piloto'
  map.impressao_lista '/impressao_lista', :controller => 'classes', :action => 'impressao_lista'
  map.impressao_bolsa_familia '/impressao_bolsa_familia', :controller => 'alunos', :action => 'impressao_bolsa_familia'
  map.impressao_relatorio_aluno '/impressao_relatorio_aluno', :controller => 'atribuicaos', :action => 'impressao_relatorio_aluno'
  map.impressao_relatorio_classe '/impressao_relatorio_classe', :controller => 'atribuicaos', :action => 'impressao_relatorio_classe'
  map.impressao_relatorio_professor '/impressao_relatorio_professor', :controller => 'atribuicaos', :action => 'impressao_relatorio_professor'
  map.impressao_nota_final '/impressao_nota_final', :controller => 'historicos', :action => 'impressao_nota_final'
  map.impressao_lancamentos '/impressao_lancamentos', :controller => 'atribuicaos', :action => 'impressao_lancamentos'
  map.impressao_alteracao_lancamentos '/impressao_alteracao_lancamentos', :controller => 'notas', :action => 'impressao_alteracao_lancamentos'
  map.impressao_lancamentos_notas '/impressao_lancamentos_notas', :controller => 'notas', :action => 'impressao_lancamentos_notas'
  map.impressao_transferencia_aluno'impressao_transferencia_aluno', :controller => 'atribuicaos', :action => 'impressao_transferencia_aluno'
  #map.impressao_historico'impressao_historico', :controller => 'atribuicaos', :action => 'impressao_historico'
  map.impressao_faltas_dia '/impressao_faltas_dia', :controller => 'aulas_faltas', :action => 'impressao_faltas_dia'
  map.impressao_faltas '/impressao_faltas', :controller => 'aulas_faltas', :action => 'impressao_faltas'
  map.impressao_faltas_professor '/impressao_faltas_professor', :controller => 'aulas_faltas', :action => 'impressao_faltas_professor'
  map.impressao_faltas_funcionario '/impressao_faltas_funcionario', :controller => 'aulas_faltas', :action => 'impressao_faltas_funcionario'
  map.impressao_eventuals '/impressao_eventuals', :controller => 'aulas_eventuals', :action => 'impressao_eventuals'
  map.impressao_eventuals_professor '/impressao_eventuals_professor', :controller => 'aulas_eventuals', :action => 'impressao_eventuals_professor'
  #map.download_historico '/download_historico', :controller => 'atribuicaos', :action => 'arquivo_historico'
  map.impressao_unidade '/impressao_unidade', :controller => 'aulas_eventuals', :action => 'impressao_unidade'
  map.impressao_chamado_manutencao '/impressao_chamado_manutencao', :controller =>'mmanutencao', :action =>'impressao_chamado_manutencao'
  map.impressao_calendar '/impressao_calendar', :controller =>'reservar_salas', :action =>'impressao_calendar'
  map.impressao_calendar_agendamento '/impressao_calendar_agendamento', :controller =>'poda_gramas', :action =>'impressao_calendar_agendamento'
  map.impressao_calendar_agenda '/impressao_calendar_agenda', :controller =>'poda_gramas', :action =>'impressao_calendar_agenda'
  map.impressao_calendar_execucoes '/impressao_calendar_execucoes', :controller =>'poda_gramas', :action =>'impressao_calendar_execucoes'
  map.impressao_calendar_nexecutado '/impressao_calendar_nexecutado', :controller =>'poda_gramas', :action =>'impressao_calendar_nexecutado'
  map.impressao_pedido '/impressao_pedido', :controller => 'orc_pedido_compras', :action => 'impressao_pedido'

  map.alteracao '/altera', :controller => 'alteracaos', :action => 'altera'
  map.alteracao_matricula '/alteracao_matricula', :controller => 'matriculas', :action => 'alteracao_matricula'
  map.editar_ficha_cadastral '/editar_ficha_cadastral', :controller => 'alunos', :action => 'editar_ficha_cadastral'
  map.editar_transferencia_aluno '/editar_transferencia_aluno', :controller => 'transferencias', :action => 'editar_transferencia_aluno'
  map.editar_classe_aluno '/editar_classe_aluno', :controller => 'classes', :action => 'editar_classe_aluno'
  map.editar_atribuicao_classe '/editar_atribuicao_classe', :controller => 'atribuicaos', :action => 'editar_atribuicao_classe'
  map.show_editar '/show_editar', :controller => 'atribuicaos', :action => 'show_editar'
  map.edit_orc_nota_fiscal_item '/edit_orc_nota_fiscal_item', :controller => 'orc_nota_fiscals', :action => 'edit_orc_nota_fiscal_item'

    

  map.consulta_E '/consulta_E', :controller => 'produtos', :action => 'consulta_E'
  map.consulta_S '/consulta_S', :controller => 'produtos', :action => 'consulta_S'
  map.consulta_professor_eventual '/consulta_professor_eventual', :controller => 'eventuals', :action => 'consultas'
  map.consulta_unidade '/consulta_unidade', :controller => 'unidades', :action => 'consulta_unidade'
  map.consulta_estagiario '/consulta_estagiario', :controller => 'estagiarios', :action => 'consulta_estagiario'
  map.consulta_funcionario '/consulta_funcionario', :controller => 'funcionarios', :action => 'consulta_funcionario'
  #map.consulta_estagiarioe '/consulta_estagiario', :controller => 'estagiarios', :action => 'consulta_estagiario'
  map.consultaprofessor '/consultaprofessor', :controller => 'professors', :action => 'consultaprofessor'
  map.consultaeventual '/consultaeventual', :controller => 'eventuals', :action => 'consultaeventual'
  map.saida_transf '/saida_transf', :controller => 'matriculas', :action => 'saida_transf'
  map.consulta_professor_nome '/consulta_professor_nome', :controller => 'professors', :action => 'consulta_nome'
  map.consulta_classe_aluno '/consulta_classe_aluno', :controller => 'classes', :action => 'consulta_classe_aluno'
  map.consulta_classe_fone1 '/consulta_classe_fone1', :controller => 'classes', :action => 'consulta_classe_fone1'
  map.consulta_classe_piloto'/consulta_classe_piloto', :controller => 'classes', :action => 'consulta_classe_piloto'
  map.consulta_piloto'/consulta_piloto', :controller => 'classes', :action => 'consulta_piloto'
  map.consulta_classe '/consulta_classe', :controller => 'classes', :action => 'consulta_classe'
  map.consulta_classe_anteriores '/consulta_classe_anteriores', :controller => 'classes', :action => 'consulta_classe_anteriores'
  map.consulta_lista_classe '/consulta_lista_classe', :controller => 'classes', :action => 'consulta_lista_classe'
  map.consulta_lista '/consulta_lista', :controller => 'classes', :action => 'consulta_lista'
  map.consulta_classe_professor '/consulta_classe_professor', :controller => 'professors', :action => 'consulta_classe_professor'
  map.consulta_classe_anterior_professor '/consulta_classe_anterior_professor', :controller => 'professors', :action => 'consulta_classe_anterior_professor'
  map.consulta_classe_nota1 '/consulta_classe_nota1', :controller => 'atribuicaos', :action => 'consulta_classe_nota1'
  map.consulta_classe_nota '/consulta_classe_nota', :controller => 'atribuicaos', :action => 'consulta_classe_nota'
  map.consultar_matricula '/consultar_matricula', :controller => 'matriculas', :action => 'consultar_matricula'
  map.consultar_relatorio '/consultar_relatorio', :controller => 'relatorio', :action => 'consulta_relatorio'
  map.consulta_atribuicao '/consulta_atribuicao', :controller => 'atribuicaos', :action => 'consulta_atribuicao'
  map.consulta_orcamentaria '/consulta_orcamentaria', :controller => 'orc_uni_orcamentarias', :action => 'consulta_orcamentaria'
  map.consulta_ficha'/consulta_ficha', :controller => 'orc_fichas', :action => 'consulta_ficha'
  map.consulta_saldo'/consulta_saldo', :controller => 'orc_fichas', :action => 'consulta_saldo'
  map.consulta_pedido'/consulta_pedido', :controller => 'orc_pedido_compras', :action => 'consulta_pedido'
  map.consulta_empenho'/consulta_empenho', :controller => 'orc_empenhos', :action => 'consulta_empenho'
  map.consulta_reserva'/consulta_reserva', :controller => 'orc_reservas', :action => 'consulta_reserva'
  map.consulta_ata'/consulta_ata', :controller => 'orc_atas', :action => 'consulta_ata'
  map.consulta_empenho_produto'/consulta_empenho_produto', :controller => 'orc_empenhos', :action => 'consulta_empenho_produto'
  map.consulta_ata_produto'/consulta_ata_produto', :controller => 'orc_atas', :action => 'consulta_ata_produto'
  map.consulta_nf'/consulta_nf', :controller => 'orc_nota_fiscals', :action => 'consulta_nf'
  map.consulta_suplementacao'/consulta_suplementacao', :controller => 'orc_suplementacaos', :action => 'consulta_suplementacao'
  map.consulta_pagamentos'/consulta_pagamentos', :controller => 'orc_pagamentos', :action => 'consulta_pagamentos'
  map.consulta_pagamento'/consulta_pagamento', :controller => 'orc_pagamentos', :action => 'consulta_pagamento'
  map.consulta_lancamento'/consulta_lancamento', :controller => 'orc_lancamentos', :action => 'consulta_lancamento'
  map.consultaSI_lancamento'/consultaSI_lancamento', :controller => 'orc_lancamentos', :action => 'consultaSI_lancamento'

  map.sem_ficha'/sem_ficha', :controller => 'orc_pedido_compras', :action => 'sem_ficha'

  map.relatorios_observacoes'/relatorios_observacoes', :controller => 'atribucaos', :action => 'relatorios_observacoes'
  map.continuar'/continuar', :controller => 'alunos', :action => 'continuar'
  map.relatorios_faltas'/relatorios_faltas', :controller => 'aulas_faltas', :action => 'relatorios_faltas'
  map.relatorios_dia_faltas'/relatorios_dia_faltas', :controller => 'aulas_faltas', :action => 'relatorios_dia_faltas'
  map.relatorios_faltas_professor'/relatorios_faltas_professor', :controller => 'aulas_faltas', :action => 'relatorios_faltas_professor'
  map.relatorios_faltas_funcionario'/relatorios_faltas_funcionario', :controller => 'aulas_faltas', :action => 'relatorios_faltas_funcionario'
  map.relatorios_eventual_professor'/relatorios_eventual_professor', :controller => 'aulas_eventuals', :action => 'relatorios_eventual_professor'
  map.relatorios_eventuals'/relatorios_eventuals', :controller => 'aulas_eventuals', :action => 'relatorios_eventuals'
  map.relatorios_agendamento'/relatorios_agendamento', :controller => 'poda_gramas', :action => 'relatorios_agendamento'
  map.relatorios_manutencaos'/relatorios_manutencaos', :controller => 'mmanutencaos', :action => 'relatorios_manutencaos'

  map.agenda_poda_grama'/agenda_poda_grama', :controller => 'poda_gramas', :action => 'agenda_poda_grama'

  #map.si_selecionados'/si_selecionados', :controller => 'orc_pedido_compras', :action => 'si_selecionados'
  map.cesta_basica '/cesta_basica', :controller => 'reservar_salas', :action => 'cesta_basica'
  map.banco_horas '/banco_horas', :controller => 'reservar_salas', :action => 'banco_horas'
  map.plano_educacao '/plano_educacao', :controller => 'reservar_salas', :action => 'plano_educacao'
  map.ata_infantil_01_03_18'/ata_infantil_01_03_18', :controller => 'reservar_salas', :action => 'ata_infantil_01_03_18'
  map.ata_coordenadores_emei_02_03_18'/ata_coordenadores_emei_02_03_18', :controller => 'reservar_salas', :action => 'ata_coordenadores_emei_02_03_18'
  map.ata_ensino_fundamental_02_03_18'/ata_ensino_fundamental_02_03_18', :controller => 'reservar_salas', :action => 'ata_ensino_fundamental_02_03_18'
  map.uso_internet '/uso_internet', :controller => 'reservar_salas', :action => 'uso_internet'


  map.fundamental_2018 '/fundamental_2018', :controller => 'reservar_salas', :action => 'fundamental_2018'
  map.infantil_2018 '/infantil_2018', :controller => 'reservar_salas', :action => 'infantil_2018'
  map.fundamental_2019 '/fundamental_2019', :controller => 'reservar_salas', :action => 'fundamental_2019'
  map.infantil_2019 '/infantil_2019', :controller => 'reservar_salas', :action => 'infantil_2019'
  map.dowloads '/dowloads', :controller => 'reservar_salas', :action => 'dowloads'
  map.substituicaos '/substituicaos', :controller => 'aulas_eventuals', :action => 'index'
  map.edit_status '/edit_status', :controller => 'matriculas', :action => 'edit_status'
  map.matriculas_saidas '/matriculas_saidas', :controller => 'matriculas', :action => 'matriculas_saidas'
  map.matriculas_saidas_seduc '/matriculas_saidas_seduc', :controller => 'matriculas', :action => 'matriculas_saidas_seduc'
  map.resources :roles_users, :collection => {:lista_users => :get}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resource :password

  map.resources :users
  map.resource :session
  map.home '', :controller => 'home', :action => 'index'
  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.geo "/geos/geo/:id", :controller => "geos", :action => "geo"

end