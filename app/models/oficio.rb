class Oficio < ActiveRecord::Base

after_create :geracodigo

def geracodigo
    #self.codigo = [self.id-612].to_s + ("/2017")
    #self.codigo = [self.id-969].to_s + ("/2018")
    #self.codigo = [self.id-1360].to_s + ("/2019")
    #self.codigo = [self.id-1802].to_s + ("/2020")
    self.codigo = [self.id-1904].to_s + ("/2021")

    self.save

end

def before_save
    self.emissor.upcase!
    self.assunto.upcase!
    self.destinatario.upcase!
    
end


end
