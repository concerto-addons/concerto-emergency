module ConcertoEmergency
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergency

    engine_name 'ems'

    initializer "register content type" do |app|
      app.config.content_types << EmergencyAlert
      app.config.content_types << EmergencyRss
    end

    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        # Add configuration options under Concerto Admin Settings
        add_config("emergency_template", "Default Template",
          :value_type => "string",
          :category => "Emergency Alerts",
          :description => "Template used to display emergency alerts")

        add_config("emergency_feed", "Concerto",
          :value_type => "string",
          :category => "Emergency Alerts",
          :description => "Feed monitored for eemergency alert content")

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Effective template hook 
        add_controller_hook "Screen", :frontend_display, :after do

          emergency_feed = Feed.find_by_name(ConcertoConfig[:emergency_feed])

          # Check for emergency content 
          if not emergency_feed.nil? and not emergency_feed.submissions.approved.active.empty?
            # swap template to emergency template if emergency content is present
            @template = Template.find_by_name(ConcertoConfig[:emergency_template])
          end

        end

        # Controller hook for frontend/contents_controller
        add_controller_hook "Frontend::ContentsController", :index, :after do

          emergency_feed = Feed.find_by_name(ConcertoConfig[:emergency_feed])
          
          if not emergency_feed.nil?
            emergency_submissions = emergency_feed.submissions.approved.active
            emergency_contents = Array.new()
            emergency_submissions.each { |submission| emergency_contents << Content.find(submission.content_id) }
        
            if not emergency_contents.empty?
              # Content supplied to screen is replaced with emergency contents
              @content = emergency_contents
            end
          end
        end

      end
    end

  end
end