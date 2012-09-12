Bkngjobs::Application.routes.draw do
  resources :jobs

  root :to => "home#index"
end
