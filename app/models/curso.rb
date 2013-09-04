class Curso < ActiveRecord::Base
  has_and_belongs_to_many :inscricaos
  has_many :unidades
  has_many :participantes
   validates_presence_of :nome, :message => ' ==> PREENCHER DE DADOS OBRIGATÓRIO <=='
   validates_presence_of :ministrante, :message => ' ==> PREENCHER DE DADOS OBRIGATÓRIO <=='


  def before_create
    self.vagas_disponiveis = self.qtde
    if self.nome.present?
      self.nome.upcase
    end
    if self.ministrante.present?
      self.ministrante.upcase
    end
    if self.obs.present?
      self.obs.upcase
    end
  end

  def existe_vaga

    if self.vagas_disponiveis == 0
      false
    else
      true
    end
  end

end
