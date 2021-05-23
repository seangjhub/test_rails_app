Rails.application.routes.draw do
  root to: 'sessions#new'
  resource :sessions, only: %i[new create destroy]
end
