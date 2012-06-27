DigitalLibrary::Application.routes.draw do
  resources :formulario_contato, only: [:new, :create]

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :usuarios, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :usuarios, only: [:index] do
    collection do
      put :atualizar_papeis
      get :buscar_por_nome
      get :usuarios_instituicao
      get :papeis
    end

    member do
      get :lista_de_revisao
      get :escrivaninha
      get :estante
      get :minhas_buscas
      get :area_privada
    end
  end

  root :to => 'pages#inicio'

  get   "/areas/:area_id/conteudos", to: "conteudos#por_area", as: :conteudos_por_area
  match "/ajuda",     :to => "pages#ajuda"
  match "/ajuda/manuais", :to => "pages#manuais"
  match "/sobre",     :to => "pages#sobre"
  match "/noticias",  :to => "pages#noticias"
  match '/adicionar_conteudo', :to => 'pages#adicionar_conteudo'
  match '/estatisticas', :to => "pages#estatisticas"
  match '/documentos_mais_acessados', :to => 'pages#documentos_mais_acessados'
  match '/graficos_de_acessos', :to => 'pages#graficos_de_acessos'
  match '/mapa_do_site', :to => 'pages#mapa_do_site'
  resources :buscas do
    post :cadastrar_mala_direta, :to => 'buscas#cadastrar_mala_direta'
    post :remover_mala_direta, :to => 'buscas#remover_mala_direta'
  end
  get :busca_avancada, to: 'buscas#busca_avancada'
  get :busca_normal, to: 'buscas#busca_normal'

  resources :tutoriais, :only => :index, :path => '/ajuda/tutoriais'
  match 'ajuda/tutoriais/*tutorial' => 'tutoriais#show', :via => :get

  resources :conteudos, except: [:index, :delete] do
    member do
      put :aprovar
      put :submeter
      put :favoritar
      put :remover_favorito
    end
    post :granularizou, on: :collection
    get "/baixar_conteudo" , :to => 'conteudos#baixar_conteudo'
  end

  resources :graos, :except => :all  do
    member do
      put :adicionar_a_cesta
      delete :remover_da_cesta
    end
    collection do
      get :cesta
      post :editar
    end
  end

  get :favoritar_graos, :to => 'graos#favoritar_graos'
  get "/cesta/baixar_conteudo", :to => 'graos#baixar_conteudo'
  get "/cesta/baixar_conteudo_em_odt", :to => 'graos#baixar_conteudo_em_odt'


  match "/areas/:id/sub_areas" => "areas#sub_areas"
  match "/instituicoes/:id/campus" => "instituicoes#campus"
  match "/eixos_tematicos/:id/cursos" => "eixos_tematicos#cursos"
  get '/editor' => 'editor#index', as: :editor
  post '/editor' => 'editor#download'
end

