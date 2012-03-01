# encoding: utf-8

def autenticar_usuario(*papeis)
  Usuario.delete_all
  usuario = Usuario.create!({ nome_completo: 'Foo Bar',
                               email: 'foo@bar.com',
                               password: 'foobar',
                               password_confirmation: 'foobar',
                               instituicao: 'iff',
                               campus: 'centro' })
  papeis.each do |papel|
    usuario.papeis << papel
    usuario.save!
  end

  visit '/usuarios/login'
  within_fieldset 'Entrar' do
    fill_in 'E-mail', with: 'foo@bar.com'
    fill_in 'Senha', with: 'foobar'
  end
  click_button 'Entrar'
end

