Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
              controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  devise_scope :user do
    get '/users/registrations/change_password', to: 'registrations#change_password', as: :change_password
    put '/users/registrations/:id/changed_password', to: 'registrations#changed_password', as: :changed_password
  end

 resources :users, only: [:show] do
   member do
    post '/verify_phone_number' => 'users#verify_phone_number'
    patch '/update_phone_number' => 'users#update_phone_number'
   end
 end

 resources :bands, except: [:edit] do
   member do
   get 'listing'
   get 'social_media'
   get 'description'
   get 'band_pic_upload'
   get 'band_music_upload'
   get 'location'
 end
   get 'published', on: :collection
  resources :pictures, only: [:create, :destroy]
  resources :band_musics, only: [:create, :destroy]
 end
 match 'band_musics/:id', to: "band_musics#show", via: :all
 resources :venues, except: [:edit] do
   member do
   get 'listing'
   get 'payout'
   get 'description'
   get 'photo_upload'
   get 'genre'
   get 'location'
   get 'preload'
   get 'preview'
   get 'get_available_times'
 end
   get 'published', on: :collection
  resources :photos, only: [:create, :destroy]
  resources :calendars
  resources :bookings, only: [:create]
 end

resources :bookings, only: [:show]
 get '/bookings/:id' => 'bookings#show'

 resources :guest_reviews, only: [:create, :destroy]
 resources :host_reviews, only: [:create, :destroy]

 get '/your_tours' => 'bookings#your_tours'
 get '/your_bookings' => 'bookings#your_bookings'

 get 'search_bands' => 'pages#search_bands'
 get 'search_shows' => 'pages#search_shows'
 get 'search_venues' => 'pages#search_venues'
 get 'switch_accounts' => 'pages#switch_accounts'
 post 'search' => 'pages#search'
 get '/terms' => 'pages#terms'
 get '/pricing' => 'pages#pricing'
  get '/contact_us' => 'pages#contact_us'
  post '/contact' => 'pages#contact'

 # --- Advanced Features ---
 get 'dashboard' => 'dashboards#index'

 resources :bookings, only: [:approve, :decline, :send_pay_request, :mark_paid] do
      member do
        post '/approve' => 'bookings#approve'
        post '/decline' => 'bookings#decline'

        get :send_pay_request
        get :mark_paid
      end
    end

    resources :revenues, only: [:index]

    resources :conversations, only: [:index, :create] do
      resources :messages, only: [:index, :create] do
        get :more_messages, on: :collection
      end
    end

    get '/host_calendar' => 'calendars#host'
    get '/guest_calendar' => 'calendars#guest'
    get '/edit_calendar/:id' => 'calendars#edit'

    get '/payment_method' => 'users#payment'
    get '/payout_method' => 'users#payout'
    post '/add_card' => 'users#add_card'

    get '/notification_settings' => 'settings#edit'
    post '/notification_settings' => 'settings#update'

    get '/notifications' => 'notifications#index'

    mount ActionCable.server => '/cable'

end
