DigitalLibrary::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  devise_for :usuarios, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :usuarios, only: [:index] do
    put :atualizar_papeis, on: :collection
    get :buscar_por_nome, on: :collection
    get :usuarios_instituicao, on: :collection
    get :area_privada
    get :minhas_buscas, :to => 'usuarios#minhas_buscas'
    member do
      get :lista_de_revisao
      get :escrivaninha
      get :estante
    end
  end
  get "usuarios/papeis", :to => "usuarios#papeis"

  root :to => 'pages#inicio'
  match "/ajuda",     :to => "pages#ajuda"
  match "/ajuda/manuais", :to => "pages#manuais"
  match "/sobre",     :to => "pages#sobre"
  match "/noticias",  :to => "pages#noticias"
  match '/adicionar_conteudo', :to => 'pages#adicionar_conteudo'
  match '/estatisticas', :to => "pages#estatisticas"
  match '/documentos_mais_acessados', :to => 'pages#documentos_mais_acessados'
  match '/graficos_de_acessos', :to => 'pages#graficos_de_acessos'
  resources :buscas do
    post :cadastrar_mala_direta, :to => 'buscas#cadastrar_mala_direta'
    post :remover_mala_direta, :to => 'buscas#remover_mala_direta'
  end
  get :busca_avancada, to: 'buscas#busca_avancada'

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

  match "/areas/:id/sub_areas" => "areas#sub_areas"
  match "/instituicoes/:id/campus" => "instituicoes#campus"
  match "/eixos_tematicos/:id/cursos" => "eixos_tematicos#cursos"
  get '/editor' => 'editor#index', as: :editor
  post '/editor' => 'editor#download'
end
