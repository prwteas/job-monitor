Bkngjobs::Application.routes.draw do
  mount Resque::Server.new, :at => "/resque"
  match 'jobs/updatedb' => 'jobs#updatedb'
  match 'jobs/open' => 'jobs#open'
  match 'jobs/closed' => 'jobs#closed'

  resources :jobs

  root :to => "home#index"
end
