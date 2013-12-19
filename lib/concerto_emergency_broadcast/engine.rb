module ConcertoEmergencyBroadcast
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergencyBroadcast

    engine_name 'ems'

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do
        add_route("ems", ConcertoEmergencyBroadcast::Engine)
      end
    end

  end
end
