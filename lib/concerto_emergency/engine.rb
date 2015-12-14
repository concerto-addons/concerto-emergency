module ConcertoEmergency
  class Engine < ::Rails::Engine

    isolate_namespace ConcertoEmergency

    engine_name 'ems'

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
          :description => "Feed monitored for emergency alert content")

        init do 
          Rails.logger.info "ConcertoEmergencyBroadcast: Initialization code is running"
        end

        # Effective template hook 
        add_controller_hook "Screen", :frontend_display, :before do

          emergency_feed = Feed.find_by_name(ConcertoConfig[:emergency_feed])
          emergency_active = emergency_feed.submissions.approved.active.includes(:content).where("kind_id != 4").present?

          # Check for emergency content 
          if not emergency_feed.nil? and emergency_active
            # swap template to emergency template if emergency content is present
            emergency_template = Template.find_by_name(ConcertoConfig[:emergency_template])
            if not emergency_template.nil?
              self.template = emergency_template
            end
          end

        end

        # Controller hook for frontend/contents_controller
        add_controller_hook "Frontend::ContentsController", :index, :after do

          emergency_feed = Feed.find_by_name(ConcertoConfig[:emergency_feed])
          emergency_active = emergency_feed.submissions.approved.active.includes(:content).where("kind_id != 4").present?
          
          if not emergency_feed.nil?
            emergency_submissions = emergency_feed.submissions.approved.active.includes(:content).where("kind_id = ?", @field.kind_id)
            emergency_contents = Array.new()
            emergency_submissions.each { |submission| emergency_contents << Content.find(submission.content_id) }
        
            if emergency_active

              # Change template identifier so the screen knows a template 
              #  is used for emergency alerts
              emergency_template = Template.find_by_name(ConcertoConfig[:emergency_template])
              if not emergency_template.nil?
                @screen.template = emergency_template
              end
              
              # Content supplied to screen is replaced with emergency contents
              @content = emergency_contents
            end
          else
            Rails.logger.error("could not find emergency feed #{ConcertoConfig[:emergency_feed]}")
          end
        end

      end
    end

  end
end
