ConcertoEmergencyBroadcast::Engine.routes.draw do
  resources :ems_config
end

Rails.application.routes.draw do
  resources :emergency_alerts, :emergency_rsses, :controller => :contents, :except => [:index, :show], :path => "content"
end
