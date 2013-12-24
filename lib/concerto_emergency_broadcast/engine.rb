module ConcertoEmergencyBroadcast
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergencyBroadcast

    engine_name 'ems'

    initializer "register content type" do |app|
      app.config.content_types << EmergencyAlert
      app.config.content_types << EmergencyRSS
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        add_controller_hook "ScreensController", :show, :before do
          
        end

        add_view_hook "ScreensController", :screen_details, :text => "hello"

      end
    end

  end
end
