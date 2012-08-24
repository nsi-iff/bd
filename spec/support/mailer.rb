module MailerMacros
  def ultimo_email_enviado
    ActionMailer::Base.deliveries.last
  end

  def resetar_emails
    ActionMailer::Base.deliveries = []
  end
end
