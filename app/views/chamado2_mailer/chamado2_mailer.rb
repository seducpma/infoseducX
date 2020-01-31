class Chamado2Mailer  < ActionMailer::Base



def notificar_chamado(chamado)
  recipients chamado.user.email
  subject "Protocolo chamado"
  from  "administrador@seducpma.com"

  body :chamado => chamado
end


def enviar_email(chamado,email)
  recipients email
  subject "Secretaria de Educação  - Solicitiação de Manutenção #{chamado.id} - Informática  "
  from  "no-replay@seducpma.com"
  #body :participante => participante, :inscricao => inscricao
  body :email => email, :chamado => chamado
end


end