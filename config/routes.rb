Rails.application.routes.draw do   
  resources :affiliations
  resources :reviews
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

  get '/manager' => 'manager#index'
  get '/manager/affiliazioni' => 'manager#affiliazioni'
  get '/manager/aziende' => 'manager#aziende'
  get '/manager/singleone' => 'manager#singleone'

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
  get "calendar/editEvent" , to: "calendar#createEvent"
  get "calendar/deleteEvent" , to: "calendar#deleteEvent"

end
