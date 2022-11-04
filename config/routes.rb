Rails.application.routes.draw do   
  resources :affiliations
  resources :reviews
  resources :videos, only: [:index, :new, :create]
  resources :video_uploads, only: [:new, :create]
  root 'pages#home'
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/profile' => 'profile#index'
  get '/profile/nameandrole' => 'profile#nameandrole'

  get '/cliente' => 'cliente#search'
  get '/cliente/function' => 'cliente#function'
  get '/cliente/managerprofile' => 'cliente#visualize'
  get '/cliente/events' => 'cliente#events' 

  # get '/cliente/createEvent' => 'cliente#createEvent'
  # get '/cliente/createEventConfirm' => 'cliente#createEventConfirm'

  # get "cliente/listEvent" , to: "cliente#listEvent"
  # get "cliente/deleteEvent" , to: "cliente#deleteEvent"

  # get "/cliente/event", to: "cliente#editEvent"
  # patch "/cliente/event", to: "cliente#reviewEvent"

  get '/manager' => 'manager#index'
  get '/manager/affiliazioni' => 'manager#affiliazioni'
  get '/manager/aziende' => 'manager#aziende'
  get '/manager/singleone' => 'manager#singleone'
  get '/manager/events' => 'manager#events' 

  get '/azienda' => 'azienda#index'
  get '/azienda/affiliazioni' => 'azienda#affiliazioni'
  
  get '/affiliations/accept' => 'affiliation#accept'

  get '/utility/annulla' => 'utility#annulla'
  
  get '/reviews' => 'review#index'
  # Defines the root path route ("/")
  # root "articles#index"
  get "calendar/createCalendar" , to: "calendar#create"
  get "calendar/updateCalendar" , to: "calendar#update"
  get "calendar/deleteCalendar" , to: "calendar#delete"

  get "calendar/createEvent" , to: "calendar#createEvent"
  post "calendar/createEventConfirm" , to: "calendar#createEventConfirm"
  get "calendar/createEventConfirm" , to: "calendar#createEventConfirm"
  get "calendar/listEvent" , to: "calendar#listEvent"
  get "calendar/deleteEvent" , to: "calendar#deleteEvent"

  get "/event", to: "calendar#editEvent"
  patch "/event", to: "calendar#reviewEvent"

  get "/YTProva", to: "youtube#youtubeListProva"

  get "/oauth2callback", to: "youtube#oauth2callback"

  #per yt
  get "/inizio", to: "yt_menu#index"
  get "/videos", to: "videos#index"
  get "/provayt1", to: "youtube#list"
  get "/provayt2", to: "youtube#youtubeListProva"
  get "/provayt3", to: "youtube#upload"
  post 'upload_video', to: 'youtube#upload', as: 'upload'

  get "/list_subs", to: "youtube#list_subs"
end
