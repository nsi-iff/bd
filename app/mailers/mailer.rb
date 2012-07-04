#encoding: utf-8

class Mailer < ActionMailer::Base
  default from: "mala_direta@iff.edu.br"

  def notificar_usuario_sobre_conteudos(usuario_email, conteudos)
    @usuario = Usuario.find_by_email(usuario_email)
    @conteudos = conteudos

    mail(to: @usuario.email, subject: 'Biblioteca Digital: Novos documentos de seu interesse')
  end

  def notificar_usuarios_referenciavel_removido(usuario, referenciavel)
    @usuario = usuario
    @referenciavel = referenciavel

    mail(from: "no_reply@iff.edu.br", to: @usuario.email,
         subject: 'Biblioteca Digital: Notificação sobre grão removido')
  end
end
