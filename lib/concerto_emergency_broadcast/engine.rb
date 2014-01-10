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

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Controller hook and view hook for Screen Show page
        # the app crashed when I didn't have these added
        add_controller_hook "ScreensController", :show, :before do
        end
        add_view_hook "ScreensController", :screen_details, :text => ""


        # Controller hook for frontend/screens_controller#show
        add_controller_hook "Frontend::ScreensController", :setup, :before do
          # Check for active EmergencyAlert Content
          emergency_contents = Submission.joins(:content).where(:submissions => {:moderation_flag => true}, :contents => {:type => 'EmergencyAlert'})
          
          # EmergencyAlert content is present, override the screen
          if not emergency_contents.empty?
            # Find our emergenct template
            emergency_template = Template.find_by_name('Emergency Template')

            # emergency template not found in database
            if emergency_template.id.nil?
              # create a new one?
            end

            # Since an emergency alert was detected, make a copy of the 
            # requested screen and modify the setup to display the alerts
            emergency_screen = @screen
            emergency_screen.template_id = emergency_template.id


            # Override the screen variable that the 
            # Frontend::ScreensController will respond with 
            @screen = emergency_screen
          end
        end

      end
    end

  end
end
