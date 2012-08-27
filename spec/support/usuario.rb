# encoding: utf-8

def autenticar_usuario(*papeis)
  deslogar
  autenticar(criar_usuario(*papeis))
end

def autenticar(usuario)
  visit '/usuarios/logout'
  visit '/usuarios/login'
  fill_in 'E-mail', with: usuario.email
  fill_in 'Senha', with: '12345678'
  click_button 'Entrar'
  usuario
end

def deslogar
  visit '/usuarios/logout'
end

def criar_usuario(*papeis)
  usuario = create(:usuario)
  papeis.each do |papel|
    usuario.papeis << papel
    usuario.save!
  end
  usuario
end

def stub_usuario(papel_ou_papeis, stub_hash)
  papeis = papel_ou_papeis.is_a?(Array) ? papel_ou_papeis : [papel_ou_papeis]
  stub_model(Usuario, 
    Papel.all.map(&:nome).reduce({}) {|hash, papel| 
      hash.merge("#{papel}?".to_sym => papeis.include?(papel))
    }.merge(stub_hash))
end
