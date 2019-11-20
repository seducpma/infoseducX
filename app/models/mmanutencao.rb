class Mmanutencao < ActiveRecord::Base

  validates_presence_of :unidade_id, :message => ' - SELECIONAR UNIDADE  - '
  belongs_to :unidade, :dependent => :destroy
  belongs_to :situacao_manutencao
  belongs_to :user
  belongs_to :funcionario
  belongs_to :chefia
  has_and_belongs_to_many :tipos_manutencaos
    #has_attached_file :photo, :styles => {:thumb=> "100x100#", :small  => "150x150>" }
      has_attached_file :photo, :styles => {:original=> "300x300>"},
                    :url => "/photos/mmanutencaos/:id.:extension",
                    :path => ":rails_root/public/photos/mmanutencaos/:id.:extension"


  accepts_nested_attributes_for :unidade
  attr_accessor :tipos_manutencao
  Solicitacao = %w(Internet E-mail Telefone Pessoalmente Outros)
  
  before_update :data_encerramento

def data_encerramento

  $teste= self.situacao_manutencao.situacao
 if ($teste == 'ENCERRADO')then
      if self.chefia_id == 1
        self.data_ate = Time.now
      else
        self.data_enc = Time.now
      end
 end

 if ($teste == 'ENCAMINHADO')then
      if self.chefia_id == 1
        
      else
        self.data_ate = Time.now
      end
 end
end

 def self.nome_unidade(unidade)
    Unidade.find(unidade).nome
  end


def self.aberto_geral
    Mmanutencao.find(:all, :conditions => ['situacao_manutencao_id <> 2 OR situacao_manutencao_id <> 9'])
end

def self.encerrado_geral
    Mmanutencao.find(:all, :conditions => ['situacao_manutencao_id = 2 OR situacao_manutencao_id = 9'])
end

def self.geral
    Mmanutencao.find(:all)
end

#======== POR UNIDADE

def self.aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all, :conditions => ['unidade_id=? AND (situacao_manutencao_id <> 2 OR situacao_manutencao_id <> 9)',unidade_id])
end

def self.encerrado_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all, :conditions => ['unidade_id=? AND (situacao_manutencao_id = 2 OR situacao_manutencao_id = 9)',unidade_id] )
end

def self.por_unidade(unidade)
     unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all, :conditions => ['unidade_id = ?', unidade_id])
end



#======== POR SERVICO



def self.alvenaria_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 1',unidade_id])
end

def self.dedetizacao_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 3',unidade_id])
end

def self.eletro_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 4',unidade_id])
end

def self.eletrica_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 5',unidade_id])
end

def self.cozinha_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 6',unidade_id])
end


def self.hidrau_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 7',unidade_id])
end

def self.limpeza_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 8',unidade_id])
end

def self.marcenaria_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 9',unidade_id])
end

def self.pintura_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 10',unidade_id])
end

def self.playground_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 11',unidade_id])
end

def self.grama_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 12',unidade_id])
end

def self.serralheria_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 13',unidade_id])
end

def self.telhado_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 14',unidade_id])
end

def self.outros_aberto_unidade(unidade)
    unidade_id = Unidade.find(unidade).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos.unidade_id=? AND (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9) AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = 15',unidade_id])
end

#====

def self.aberto_servico(servico)
    servico_id = TiposManutencao.find(servico).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => [' (mmanutencaos.situacao_manutencao_id <> 2 AND mmanutencaos.situacao_manutencao_id <> 9)  AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = ?',servico_id])
    #Mmanutencao.find(:all, :conditions => ['unidade_id=? AND situacao_manutencao_id <> 2',unidade_id])
end

def self.encerrado_servico(servico)
    servico_id = TiposManutencao.find(servico).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['(mmanutencaos.situacao_manutencao_id = 2 or mmanutencaos.situacao_manutencao_id = 9 )AND mmanutencaos_tipos_manutencaos.tipos_manutencao_id = ?',servico_id])
    #Mmanutencao.find(:all, :conditions => ['unidade_id=? AND situacao_manutencao_id == 2',unidade_id] )

end

def self.por_servico(servico)
     servico_id = TiposManutencao.find(servico).id
    Mmanutencao.find(:all,  :joins => "INNER JOIN mmanutencaos_tipos_manutencaos ON mmanutencaos.id = mmanutencaos_tipos_manutencaos.mmanutencao_id", :conditions => ['mmanutencaos_tipos_manutencaos.tipos_manutencao_id = ?',servico_id])
    #Mmanutencao.find(:all, :conditions => ['unidade_id = ?', unidade_id])
end

 def self.servico(servico)
    servico_id = TiposManutencao.find(servico).id
    TiposManutencao.find(servico).servico
  end




end

