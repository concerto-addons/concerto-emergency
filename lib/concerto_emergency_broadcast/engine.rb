module ConcertoEmergencyBroadcast
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergencyBroadcast

    engine_name 'ems'

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        add_route("ems", ConcertoEmergencyBroadcast::Engine)

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        add_controller_hook "ScreensController", :show, :before do
          @alert = Alert.new
        end

        add_view_hook "ScreensController", :screen_details, :partial => "concerto_emergency_broadcast/alerts/send_alert"

      end
    end

  end
end
