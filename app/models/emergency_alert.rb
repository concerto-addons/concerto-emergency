class EmergencyAlert < Content

  DISPLAY_NAME = 'Emergency Alert'

  after_initialize :set_kind, :create_config
  after_find :load_config

  before_validation :save_config
  before_save :convert_textile

  attr_accessor :config

  def self.form_attributes
    attributes = super()
    attributes.concat([:config => :alert])
  end

  def set_kind 
    return unless (new_record? && self.kind.nil?)
    self.kind = Kind.where(:name => 'Graphics').first
  end

  def create_config
    self.config = {} if !self.config
  end

  def load_config
    self.config = JSON.load(self.data)
  end

  def save_config 
    self.data = JSON.dump(self.config)
  end

  def render_details
    { :alert => self.config['alert'] }
  end

  def sanitize_html
    self.config['alert'] = self.class.clean_html(self.config['alert']) unless self.config['alert'].nil?
  end

  def convert_textile 
    self.config['alert'] = RedCloth.new(self.config['alert']).to_html
    sanitize_html
  end

  def self.clean_html(html)
    ActionController::Base.helpers.sanitize(html, :tags => %w(b br i em li ol u ul p q small strong), :attributes => %w(style class)) unless html.nil?
  end

end