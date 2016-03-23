Rails.application.routes.draw do
  LOCALES = /en|pt\-BR/

  scope "(:locale)", :locale => LOCALES do
    resources :rooms do
      resources :reviews, :only => [:create, :update], :module => :rooms
    end
    resources :users

    resource :user_confirmation, :only => [:show]
    resource :user_sessions, :only => [:create, :new, :destroy]
  end

  match '/:locale' => 'home#index', :locale => LOCALES, via: [:get]
  root :to => "home#index"
end
