class Estagiario < ActiveRecord::Base
  belongs_to :unidade
  belongs_to :regiao

  #  before_save :etinerancia
  before_update :sem_est, :if => :verify?
  before_save :com_est, :if => :verify?
  before_update :sai, :if => :verify?
  has_attached_file :photo, :styles => {:thumb=> "100x100#", :small  => "150x150>" }

  def verify?
    self.unidade_id.present?
  end


  def self.type(estagiario)
    find(estagiario).periodo_trab
  end

  def to_param
    "#{id}-#{nome}"
  end
protected

#def etinerancia

 #    if (self.periodo_trab == 'ITINERANTE' ) then
  #      self.etinerante = 1
   #     self.unidade_id = nil
   #  else
   #     self.etinerante = 0



    # end
 # end

def desliga
   if desligado == false then
    return "NÃO"
   else
      return "SIM"
   end

  end
  def sai
   if desligado == 1 then
     @unidade=Unidade.find(self.unidade_id)
     if (self.periodo_trab == 'MATUTINO') then
         @unidade.estagiarioM = 0
     end
     if (self.periodo_trab == 'VESPERTINO') then
      @unidade.estagiarioV = 0
     end
     if (self.periodo_trab == 'NOTURNO') then
      @unidade.estagiarioN = 0
     end
     @unidade.save
   else
     @unidade=Unidade.find(self.unidade_id)
     if (self.periodo_est == 'MATUTINO') then
         @unidade.estagiarioM = 1
     end
     if (self.periodo_est == 'VESPERTINO') then
       @unidade.estagiarioV = 1
     end
     if (self.periodo_trab == 'NOTURNO') then
      @unidade.estagiarioN = 1
     end
     @unidade.save
   end

  end

def sem_est

 $teste= self.periodo_trab
 if ($teste == 'MATUTINO')then
  @unidade=Unidade.find(self.unidade_id)
   if self.desligado == 1 then
      @unidade.estagiarioM = 0
    else
      @unidade.estagiarioM = 1
    end
    @unidade.save
 end
 if ($teste == 'VESPERTINO')then
  @unidade=Unidade.find(self.unidade_id)
   if self.desligado == 1 then
      @unidade.estagiarioV = 0
    else
      @unidade.estagiarioV = 1
    end
    @unidade.save
  end
 if ($teste == 'ITINERANTE')then
  @unidade=Unidade.find(self.unidade_id)
   if self.desligado == 1 then
      @unidade.estagiarioE = 0
    else
      @unidade.estagiarioE = 1
    end
    @unidade.save
  end
   if ($teste == 'NOTURNO')then
  @unidade=Unidade.find(self.unidade_id)
   if self.desligado == 1 then
      @unidade.estagiarioN = 0
    else
      @unidade.estagiarioN = 1
    end
    @unidade.save
  end
end

def com_est

 $teste= self.periodo_trab
 if ($teste == 'MATUTINO')then
  @unidade=Unidade.find(self.unidade_id)
  @unidade.estagiarioM = 1
  @unidade.save
 end
 if ($teste == 'VESPERTINO')then
  @unidade=Unidade.find(self.unidade_id)
  @unidade.estagiarioV = 1
  @unidade.save
  end
 if ($teste == 'NOTURNO')then
  @unidade=Unidade.find(self.unidade_id)
  @unidade.estagiarioN = 1
  @unidade.save
  end
end

 def before_save
    if  !self.endereco.nil?
       self.endereco.upcase!
    end
    if  !self.complemento.nil?
       self.complemento.upcase!
    end
    if  !self.bairro.nil?
        self.bairro.upcase!
    end
    if  !self.cidade.nil?
       self.cidade.upcase!
    end
    if  !self.faculdade.nil?
         self.faculdade.upcase!
    end
    if  !self.responsavel.nil?
         self.responsavel.upcase!
    end
    if  !self.aval.nil?
        self.aval.upcase!
    end
    if  !self.obs.nil?
         self.obs.upcase!
    end
end

 
end
