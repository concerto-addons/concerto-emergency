Rails.application.routes.draw do 
  resources :emergency_alerts, :controller => :contents, :except => [:index, :show], :path => "content"
end
