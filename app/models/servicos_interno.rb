class ServicosInterno < ActiveRecord::Base

  after_create :geracodigo

def geracodigo
    #self.codigo = [self.id-782].to_s + ("/2017")
    #self.codigo = [self.id-1124].to_s + ("/2018")   # igual ao ultimo registro de 2017
    #self.codigo = [self.id-1483].to_s + ("/2019")   # igual ao ultimo registro de 2018
    #self.codigo = [self.id-1757].to_s + ("/2020")   # igual ao ultimo registro de 2019
    #self.codigo = [self.id-1757].to_s + ("/2020")   # igual ao ultimo registro de 2020
    self.codigo = [self.id-1841].to_s + ("/2021")   # igual ao ultimo registro de 2019
    self.save

end

def before_save
    self.emissor.upcase!
    self.assunto.upcase!
    self.destinatario.upcase!

end




end
