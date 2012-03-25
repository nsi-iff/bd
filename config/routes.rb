DigitalLibrary::Application.routes.draw do
  devise_for :usuarios, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :usuarios, only: [:index] do
    put :atualizar_papeis, on: :collection
    get :buscar, on: :collection
    member do
      get :lista_de_revisao
      get :escrivaninha
      get :estante
    end
    resources :buscas
  end

  root :to => 'pages#inicio'
  match "/busca",     :to => "busca#index"
  match "/ajuda",     :to => "pages#ajuda"
  match "/sobre",     :to => "pages#sobre"
  match "/noticias",  :to => "pages#noticias"
  match '/adicionar_conteudo', :to => 'pages#adicionar_conteudo'
  match '/estatisticas', :to => "pages#estatisticas"
  match '/documentos_mais_acessados', :to => 'pages#documentos_mais_acessados'

  resources :artigos_de_evento, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'artigos_de_evento#aprovar'
    get :submeter, :to  => 'artigos_de_evento#submeter'
    get :favoritar
  end
  resources :artigos_de_periodico, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'artigos_de_periodico#aprovar'
    get :submeter, :to  => 'artigos_de_periodico#submeter'
    get :favoritar
  end
  resources :livros, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'livros#aprovar'
    get :submeter, :to  => 'livros#submeter'
    get :favoritar
  end
  resources :periodicos_tecnico_cientificos, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'periodicos_tecnico_cientificos#aprovar'
    get :submeter, :to  => 'periodicos_tecnico_cientificos#submeter'
    get :favoritar
  end
  resources :relatorios,  :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'relatorios#aprovar'
    get :submeter, :to  => 'relatorios#submeter'
    get :favoritar
  end
  resources :objetos_de_aprendizagem, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'objetos_de_aprendizagem#aprovar'
    get :submeter, :to  => 'objetos_de_aprendizagem#submeter'
    get :favoritar
  end
  resources :trabalhos_de_obtencao_de_grau, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'trabalhos_de_obtencao_de_grau#aprovar'
    get :submeter, :to  => 'trabalhos_de_obtencao_de_grau#submeter'
    get :favoritar
  end
  match "/areas/:id/sub_areas" => "areas#sub_areas"
  match "/eixos_tematicos/:id/cursos" => "eixos_tematicos#cursos"
end
