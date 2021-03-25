class MmanutencaoMailer < ActionMailer::Base

def notificar_mmanutencao(mmanutencao)
  recipients mmanutencao.user.email
  subject "Protocolo Manutenção"
  from  "administrador@seducpma.com"
  
  body :mmanutencao => mmanutencao
end


def enviar_email(mmanutencao,email)
  recipients email
  subject "Secretaria de Educação   O.S. #{mmanutencao.id}  "
  from  "no-replay@seducpma.com"
  #body :participante => participante, :inscricao => inscricao
  body :email => email, :mmanutencao => mmanutencao
end

def devolucao_email(mmanutencao,email)
  recipients email
  subject "Secretaria de Educação   O.S. #{mmanutencao.id}  "
  from  "no-replay@seducpma.com"
  #body :participante => participante, :inscricao => inscricao
  body :email => email, :mmanutencao => mmanutencao
end

end
