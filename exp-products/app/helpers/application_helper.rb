# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def verified_style(object)
    return style = object.verified == true ? 'green' : 'red'
  end
  
end
