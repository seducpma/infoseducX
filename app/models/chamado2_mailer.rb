class Chamado2Mailer  < ActionMailer::Base
#  def forgot_password(user)
#    setup_email(user)
#    @subject += ' Alteração de senha'
#    if RAILS_ENV == "production"
#      @body[:url]  = "http://infoseduc.seducpma.com/reset_password/#{user.password_reset_code}"
#    else
#      @body[:url]  = "http://localhost:3000/reset_password/#{user.password_reset_code}"
#    end
#  end

 

 #   def setup_email(user)
 #     @recipients  = "#{user.email}"
 #     @from        = "no-reply@seducpma.com"
 #     @subject     = "SEDUC INFORMÁTICA -"
 #     @sent_on     = Time.now
 #     @body[:user] = user
 #   end
#end


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