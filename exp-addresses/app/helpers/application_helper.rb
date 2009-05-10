# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def document_title
    [controller.controller_name, controller.action_name].join(' | ')
  end
  
  def page_title(t)
    content_for :page_title do
      t
    end
  end
  
end
