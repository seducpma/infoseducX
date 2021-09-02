
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  
   before_filter :set_current_user

def set_current_user
    User.current = current_user

# Inicio - Alex 2018-09-12
   if RAILS_ENV=='production'
       session[:base]= 'sisgered_production'
       session[:baseinfo]= 'infoseduc_production'
   end
   if RAILS_ENV=='development'
       session[:base]= 'sisgered_development'
       session[:baseinfo]= 'infoseduc_development'
   end
#   Fim - Alex 2018-09-12

#       session[:base]= 'sisgered_development'
#       session[:baseinfo]= 'infoseduc_development'
                                                                                                                                                                                                                                                                             session[:Timeh]= Date.current.to_time.to_i
                                                                                                                                                                                                                                                                             
 #     session[:base]= 'sisgered_production'
 #     session[:baseinfo]= 'infoseduc_production'

end

private

  def current_cart
    @current_cart ||= Cart.first(:conditions => ["user_id = ?", current_user]) || Cart.create(:user_id => current_user.id)
  end

end

CHORARIA = {'30 H/S' => '30 H/S', '25 H/S' => '25 H/S','20 H/S' => '20 H/S' }
PERIODOT = {'MATUTINO' => 'MATUTINO',  'VESPERTINO' => 'VESPERTINO', 'NOTURNO' => 'NOTURNO', 'INTEGRAL' => 'INTEGRAL'}
SOLICITACAO = {'TELEFONE' => 'TELEFONE',  'E-MAIL' => 'E-MAIL', 'INTERNET' => 'INTERNET','PESSOALMENTE' => 'PESSOALMENTE', 'TERCEIROS'=> 'TERCEIROS', 'OUTROS'=>'OUTROS'}
LOCAL = {'IN-LOCU' => 'IN-LOCU',  'INFORMATICA' => 'INFORMATICA', 'OUTROS'=>'OUTROS'}

TIPOUNIDADE ={ "CAIC" =>"1",
               "CASA DA CRIANCA" =>"2",
               "EDUCAÇÃO ESPECIAL"  =>"3",
               "CIEP" => "4",
               "CRECHE" =>"5",
               "EMEF" =>"6",
               "EMEI" =>"7",
               "SEDUC" =>"8",
               "ITINERANCIA" =>"9"
             }


CURRICULO={ 'B '=>'BASICO',
            'D'=> 'DIVERSIFICADO'
          }

CATEGORIA={ 'ADI'=> 'ADI',
            'PA '=>'PA',
            'PC '=>'PC',
            'PB'=> 'PB',
            'PB-I'=> 'PB-I',
            'PB-II'=> 'PB-II'
          }
          
 
PERIODO={ ' -- Selecionar --'=>' -- Selecionar --',
          'MATUTINO '=>'MATUTINO',
          'VESPERTINO'=> 'VESPERTINO',
          'INTEGRAL'=> 'INTEGRAL' 
          }

MES ={'-- Selecionar -- '=> 0,
       'JANEIRO' => '01',
       'FEVEREIRO' => '02',
       'MARÇO' => '03',
       'ABRIL' => '04',
       'MAIO' => '05',
       'JUNHO' => '06',
       'JULHO' => '07',
       'AGOSTO' => '08',
       'SETEMBRO' => '09',
       'OUTUBRO' => '10',
       'NOVEMBRO' => '11',
       'DEZEMBRO' => '12'
       }


FALTA ={ '-- Selecionar -- ' => 'Selecionar',
         'JUSTIÇA ELEITORAL' => 'JUSTIÇA ELEITORAL',
         'FALTA ABONADA' => 'FALTA ABONADA',
         'FALTA JUSTIFICADA' => 'FALTA JUSTIFICADA',
         'ATESTADO MÉDICO' => 'ATESTADO MÉDICO',
         'LICENÇA MÉDICA' => 'LICENÇA MÉDICA',
         'LICENÇA GESTANTE' => 'LICENÇA GESTANTE',
         'FALTA INJUSTIFICADA' => 'FALTA INJUSTIFICADA',
         'OUTRAS' => 'OUTRAS'
       }
       
CARGO = {'Diretor Ed. Básica'=> 'Diretor Ed. Básica',
          'Prof. Coordenador'=>'Prof. Coordenador',
          'Pedagogo'=> 'Pedagogo',
          'ADI'=>'ADI',
          'Prof. de Creche'=>'Prof. de Creche',
          'PEB1 - Ed. Infantil'=> 'PEB1 - Ed. Infantil',
          'PEB1 - Ensino Fundamental'=> 'PEB1 - Ensino Fundamental',
          'PEB2 - Artes'=> 'PEB2 - Artes',
          'PEB2 - Ed. Física'=> 'PEB2 - Ed. Física',
          'PEB2 - História'=> 'PEB2 - História',
          'PEB2 - Geografia'=> 'PEB2 - Geografia',
          'PEB2 - Matemática'=> 'PEB2 - Matemática',
          'PEB2 - Português'=> 'PEB2 - Português',
          'PEB2 - Inglês'=> 'PEB2 - Inglês',
          'PEB2 - Ciências'=> 'PEB2 - Ciências',
          'PEB - Ed. Especial'=> 'PEB - Ed. Especial',
          'TODOS' => 'TODOS'
          }

DIAS ={ '01' => '01',
       '02' => '02',
       '03' => '03',
       '04' => '04',
       '05' => '05',
       '06' => '06',
       '07' => '07',
       '08' => '08',
       '09' => '09',
       '10' => '10',
       '11' => '11',
       '12' => '12',
       '13' => '13',
       '14' => '14',
       '15' => '15',
       '16' => '16',
       '17' => '17',
       '18' => '18',
       '19' => '19',
       '20' => '20',
       '21' => '21',
       '22' => '22',
       '23' => '23',
       '24' => '24',
       '25' => '25',
       '26' => '26',
       '27' => '27',
       '28' => '28',
       '29' => '29',
       '30' => '30',
       '31' => '31'
       }

UNIDADE = {'KG' => 'KG',  'UNIDADE' => 'UNIDADE', 'METROS'=>'METROS', 'LITROS' => 'LITROS', 'PACOTE' => 'PACOTE'}

FONTE ={ '1' => '1',   '2' => '2',  '5' => '5'}

#PERIODO ={ 'MATUTINO' => 'MATUTINO',   'VESPERTINO' => 'VESPERTINO'}

MODALIDADE ={ 'COMPRA DIRETA' => 'COMPRA DIRETA',   'PREGÃO ELETRÔNICO' => 'PREGÃO ELETRÔNICO',  'PREGÃO PRESENCIAL' => 'PREGÃO PRESENCIAL', 'TOMADA PREÇO'=> 'TOMADA PREÇO', 'CARTA CONVITE' => 'CARTA CONVITE' , 'CONCORRÊNCIA PÚBLICA'=> 'CONCORRÊNCIA PÚBLICA', 'DISPENSA DE LICITAÇÃO'=> 'DISPENSA DE LICITAÇÃO'}

