# encoding: UTF-8

require "spec_helper"

describe 'Buscas por estado do conteúdo', busca: true do
  context 'Gestor e administrador de instituicao' do
    before(:each) do
      Tire.criar_indices
      Papel.criar_todos
      @iff = Instituicao.create(nome: 'IFF')
      @campos_centro = Campus.create nome: 'Campos Centro', instituicao: @iff
      @artigo_1 = create(:artigo_de_evento, titulo: 'artigo do iff', campus: @campos_centro)
      @artigo_2 = create(:artigo_de_evento, titulo: 'artigo 2 do iff', campus: @campos_centro)
      @artigo_3 = create(:artigo_de_evento, titulo: 'artigo 3 do iff', campus: @campos_centro)
      uff = Instituicao.create(nome: 'UFF')
      campus = Campus.create nome: 'Campus', instituicao: uff
      @artigo_4 = create(:artigo_de_evento, titulo: 'artigo 1 da uff', campus: campus)
      @artigo_5 = create(:artigo_de_evento, titulo: 'artigo 2 da uff', campus: campus)
      @usuario_gestor = create(:usuario, papeis: [Papel.gestor], campus: @campos_centro)
      @usuario_admin_inst = create(:usuario, papeis: [Papel.instituicao_admin], campus: @campos_centro)
    end

    it 'podem buscar conteudos pendentes' do
      @artigo_2.submeter! #pendente
      aprovar(@artigo_3) #publicado
      @artigo_4.submeter! #pendente mas de outra instituicao
      Conteudo.index.refresh

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_gestor
      resultado = busca.buscar_em_conteudos({state: ['pendente']})
      resultado[0].titulo.should == 'artigo 2 do iff'
      resultado.size.should == 1

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_admin_inst
      resultado = busca.buscar_em_conteudos({state: ['pendente']})
      resultado[0].titulo.should == 'artigo 2 do iff'
      resultado.size.should == 1
    end

    it 'podem buscar conteudos recolhidos' do
      @artigo_2.submeter! #pendente
      aprovar(@artigo_3) #publicado
      @artigo_3.recolher!
      Conteudo.index.refresh

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_gestor
      resultado = busca.buscar_em_conteudos({state: ['recolhido']})
      resultado[0].titulo.should == 'artigo 3 do iff'
      resultado.size.should == 1

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_admin_inst
      resultado = busca.buscar_em_conteudos({state: ['recolhido']})
      resultado[0].titulo.should == 'artigo 3 do iff'
      resultado.size.should == 1
    end

    it 'não podem buscar conteudos de outra instituicao que nao estejam publicados' do
      @artigo_2.submeter! #pendente
      aprovar(@artigo_3) #publicado
      @artigo_4.submeter! #pendente mas de outra instituicao
      aprovar(@artigo_5)  #aprovado de outra instituicao
      Conteudo.index.refresh

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_gestor
      resultado = busca.buscar_em_conteudos({state: ['pendente', 'publicado']})
      resultado.size.should == 3
      titulos = resultado.map { |c| c.titulo  }
      titulos.should include('artigo 2 do iff')
      titulos.should include('artigo 3 do iff')
      titulos.should include('artigo 2 da uff')
      titulos.should_not include('artigo 1 da uff') #por ser de outra instituicao

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_admin_inst
      resultado = busca.buscar_em_conteudos({state: ['pendente', 'publicado']})
      resultado.size.should == 3
      titulos = resultado.map { |c| c.titulo  }
      titulos.should include('artigo 2 do iff')
      titulos.should include('artigo 3 do iff')
      titulos.should include('artigo 2 da uff')
      titulos.should_not include('artigo 1 da uff') #por ser de outra instituicao
    end

    it 'Gestor não pode buscar por conteudo editavel' do
      @artigo_2.submeter! #pendente
      aprovar(@artigo_3) #publicado
      Conteudo.index.refresh

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_gestor
      resultado = busca.buscar_em_conteudos({state: ['editavel']})
      resultado.size.should == 0

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_gestor
      resultado = busca.buscar_em_conteudos({state: ['editavel', 'pendente']})
      resultado[0].titulo.should == 'artigo 2 do iff'
      resultado.size.should == 1
    end
  end

  context 'administrador de instituicao' do
    before(:each) do
      Tire.criar_indices
      Papel.criar_todos
      @iff = Instituicao.create(nome: 'IFF')
      @campos_centro = Campus.create nome: 'Campos Centro', instituicao: @iff
      @artigo_1 = create(:artigo_de_evento, titulo: 'artigo do iff', campus: @campos_centro)
      @artigo_2 = create(:artigo_de_evento, titulo: 'artigo 2 do iff', campus: @campos_centro)
      @artigo_3 = create(:artigo_de_evento, titulo: 'artigo 3 do iff', campus: @campos_centro)
      uff = Instituicao.create(nome: 'UFF')
      campus = Campus.create nome: 'Campus', instituicao: uff
      @artigo_4 = create(:artigo_de_evento, titulo: 'artigo 1 da uff', campus: campus)
      @usuario = create(:usuario, papeis: [Papel.instituicao_admin], campus: campus)
      Conteudo.index.refresh
    end

    it 'pode buscar conteudos editáveis de sua instituicao' do
      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario
      resultado = busca.buscar_em_conteudos({state: ['editavel']})
      resultado[0].titulo.should == 'artigo 1 da uff'
      resultado.size.should == 1
    end
  end

  context 'Administrador geral' do
    before(:each) do
      Tire.criar_indices
      Papel.criar_todos
      @iff = Instituicao.create(nome: 'IFF')
      @campos_centro = Campus.create nome: 'Campos Centro', instituicao: @iff
      @artigo_1 = create(:artigo_de_evento, titulo: 'artigo do iff', campus: @campos_centro)
      @artigo_2 = create(:artigo_de_evento, titulo: 'artigo 2 do iff', campus: @campos_centro)
      @artigo_3 = create(:artigo_de_evento, titulo: 'artigo 3 do iff', campus: @campos_centro)
      uff = Instituicao.create(nome: 'UFF')
      campus = Campus.create nome: 'Campus', instituicao: uff
      @artigo_4 = create(:artigo_de_evento, titulo: 'artigo 1 da uff', campus: campus)
      @artigo_5 = create(:artigo_de_evento, titulo: 'artigo 2 da uff', campus: campus)
      @usuario_admin = create(:usuario, papeis: [Papel.admin], campus: campus)
    end

    it 'pode buscar conteudo editavel, pendente, publicado e recolhido de qualquer instuicao' do
      @artigo_2.submeter!
      aprovar(@artigo_3)
      @artigo_4.submeter!
      aprovar(@artigo_5)
      @artigo_5.recolher!
      Conteudo.index.refresh
      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_admin
      resultado = busca.buscar_em_conteudos({state: ['editavel', 'recolhido', 'publicado', 'pendente']})
      resultado.size.should == 5

      titulos = resultado.map { |c| c.titulo  }
      titulos.should include('artigo do iff')
      titulos.should include('artigo 2 do iff')
      titulos.should include('artigo 3 do iff')
      titulos.should include('artigo 1 da uff')
      titulos.should include('artigo 2 da uff')
    end
  end

  context 'Membro, contribuidor e usuário não logado' do
    before(:each) do
      Tire.criar_indices
      Papel.criar_todos
      iff = Instituicao.create(nome: 'IFF')
      campos_centro = Campus.create nome: 'Campos Centro', instituicao: iff
      @artigo_1 = create(:artigo_de_evento, titulo: 'artigo do iff', campus: campos_centro)
      @artigo_2 = create(:artigo_de_evento, titulo: 'artigo 2 do iff', campus: campos_centro)
      @artigo_3 = create(:artigo_de_evento, titulo: 'artigo 3 do iff', campus: campos_centro)
      uff = Instituicao.create(nome: 'UFF')
      campus = Campus.create nome: 'Campus', instituicao: uff
      @usuario_membro = create(:usuario, papeis: [Papel.membro], campus: campus)
      @usuario_contribuidor = create(:usuario, papeis: [Papel.membro], campus: campus)
    end

    it 'podem buscar somente conteúdos publicados de qualquer instituicao' do
      @artigo_2.submeter! #pendente
      aprovar(@artigo_3) #publicado
      Conteudo.index.refresh

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_membro
      resultado = busca.buscar_em_conteudos()
      resultado[0].titulo.should == 'artigo 3 do iff'
      resultado.size.should == 1

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = @usuario_contribuidor
      resultado = busca.buscar_em_conteudos()
      resultado[0].titulo.should == 'artigo 3 do iff'
      resultado.size.should == 1

      busca = Busca.new(busca: 'artigo', parametros: {})
      busca.usuario_logado = nil
      resultado = busca.buscar_em_conteudos()
      resultado[0].titulo.should == 'artigo 3 do iff'
      resultado.size.should == 1
    end
  end
end