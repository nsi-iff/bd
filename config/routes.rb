DigitalLibrary::Application.routes.draw do
  devise_for :usuarios, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :usuarios, only: [:index] do
    put :atualizar_papeis, on: :collection
    get :buscar, on: :collection
    member do
      get :escrivaninha
      get :estante
    end
  end
  get :conteudos_pendentes, :to => 'usuarios#conteudos_pendentes'

  root :to => 'pages#inicio'
  match "/busca",     :to => "busca#index"
  match "/ajuda",     :to => "pages#ajuda"
  match "/sobre",     :to => "pages#sobre"
  match "/noticias",  :to => "pages#noticias"
  match '/adicionar_conteudo', :to => 'pages#adicionar_conteudo'
  match '/estatisticas', :to => "pages#estatisticas"

  resources :artigos_de_evento, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'artigos_de_evento#aprovar'
  end
  resources :artigos_de_periodico, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'artigos_de_periodico#aprovar'
  end
  resources :livros, :only => [:new, :create, :show, :edit, :update] do
    get :submeter, :to  => 'livros#submeter'
    get :aprovar, :to  => 'livros#aprovar'
  end
  resources :periodicos_tecnico_cientificos, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'periodicos_tecnico_cientificos#aprovar'
  end
  resources :relatorios,  :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'relatorios#aprovar'
  end
  resources :objetos_de_aprendizagem, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'objetos_de_aprendizagem#aprovar'
  end
  resources :trabalhos_de_obtencao_de_grau, :only => [:new, :create, :show, :edit, :update] do
    get :aprovar, :to  => 'trabalhos_de_obtencao_de_grau#aprovar'
  end
  match "/areas/:id/sub_areas" => "areas#sub_areas"
  match "/eixos_tematicos/:id/cursos" => "eixos_tematicos#cursos"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

