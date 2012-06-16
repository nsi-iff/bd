class FormularioContato < MailForm::Base
  attribute :nome, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :assunto, validate: true
  attribute :mensagem, validate: true

  def headers
    {
      subject: "Contato",
      to: "bernardo.fire@gmail.com",
      from: %("#{nome}" <#{email}>)
    }
  end
end
