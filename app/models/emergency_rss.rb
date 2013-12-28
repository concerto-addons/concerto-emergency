class EmergencyRss < SimpleRss

  DISPLAY_NAME = 'Emergency RSS'

  def build_content
    contents = super
    emergency_style = "<div style='background-color: red; color: black;'>"
    
    contents.each do |c|
      c.name = emergency_style + c.name + "</div>"
      c.data = emergency_style + c.data + "</div>"
    end
    
    return contents
  end

end
