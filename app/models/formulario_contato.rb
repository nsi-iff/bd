class FormularioContato < MailForm::Base
  attribute :nome, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :assunto, validate: true
  attribute :mensagem, validate: true


  def headers
    binding.pry
    {
      subject: "Contato BD",
      to: YAML::load_file(File.join(Rails.root, 'config', 'contato.yml'))['contato']['email'],
      from: %("#{nome}" <#{email}>)
    }
  end
end
