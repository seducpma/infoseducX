class ServicosInterno < ActiveRecord::Base

  after_create :geracodigo

def geracodigo
    #self.codigo = [self.id-782].to_s + ("/2017")
    self.codigo = [self.id-1125].to_s + ("/2017")
    self.save

end

def before_save
    self.emissor.upcase!
    self.assunto.upcase!
    self.destinatario.upcase!

end




end
