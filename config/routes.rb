Rails.application.routes.draw do
  
  resources :boards
  resources :users
  resources :boards do
    member do # Se utiliza member cuando me interesa modificar uno solo
      put :joingame
      post :play
    end
  end 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
