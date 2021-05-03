Rails.application.routes.draw do
  root ''
  resources :artists do
    resources :albums, :tracks
  end

  resources :albums do
    resources :tracks
  end

  resources :tracks
end

