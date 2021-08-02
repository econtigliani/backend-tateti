Rails
  .application
  .routes
  .draw do
    resources :boards do
      member do
        # Se utiliza member cuando me interesa modificar uno solo
        put :joingame #Sumarse
        put :play # Agregar X o O  Cambiar por Put Patch actualiza algo puntual
      end
    end

    resources :users, only: %i[index create] do
      member do
        post :disable # Deshabilitar usuario
        post :enable # Habilitar usuario
      end
      collection do
        post :password
        post :signin , via: :options
        get :signout
        get :current
      end
    end
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
