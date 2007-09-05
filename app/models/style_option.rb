class StyleOption < ActiveRecord::Base
  
  belongs_to :style

  def display_name
    name.humanize.titleize
  end
  
  def default_value
    @config['default']
  end

  def evaluated_value
    value && !value.empty? ? value : default_value
  end
  
  def color?
    @config['type'] == :color
  end
  
  def config=(h)
    @config = h
    write_attribute(:name, h['name'])
  end
end
