module ConcertoEmergencyBroadcast
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergencyBroadcast

    engine_name 'ems'

    initializer "register content type" do |app|
      app.config.content_types << EmergencyAlert
      app.config.content_types << EmergencyRss
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        add_route("ems", ConcertoEmergencyBroadcast::Engine)

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Effective template hook 
        add_controller_hook "Screen", :effective_template, :after do

          emergency_content = Content.where(:type => "EmergencyAlert")

          # Check for emergency content 
          if not emergency_content.nil? and not emergency_content.empty?
            # swap template to emergency template if emergency content is present
            @template = Template.find_by_name("Emergency Template")
          end

        end

        # Controller hook for frontend/contents_controller
        add_controller_hook "Frontend::ContentsController", :index, :before do

          emergency_content = Content.where(:type => "EmergencyAlert")
          
          if not emergency_content.nil? and not emergency_content.empty?
            # Content supplied to screen is replaced with emergency contents
            @content = emergency_content
          end

        end

        # Controller hook and view hook for Screen Show page
        # the app crashed when I didn't have these added
        add_controller_hook "ScreensController", :show, :before do
          if EmsConfig.first.nil?
            EmsConfig.create(:template_id => 0, :feed_id => 0)
          end
          @ems_config = EmsConfig.first
        end
        add_view_hook "ScreensController", :screen_details, :partial => "concerto_emergency_broadcast/ems_config/screen_details"
      end
    end

  end
end