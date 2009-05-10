class CustomForm < ActionView::Helpers::FormBuilder

  #custom form builder for login view
  %w[text_field password_field text_area].each do |method_name|
    define_method(method_name) do |field_name, *args|
      options = args.extract_options!

      # Create field
      field = @template.content_tag(:dt, label(field_name, options[:label]))

      # Add field element
      field += @template.content_tag(:dd, super)

      # # Add notice message
      # field += @template.content_tag(:dd, options[:notice], :class => ‘notice’) if options[:notice]

      # # Render field container with all elements
      # @template.content_tag(:dl, field, :class => field_style(field_name))
    end
  end
  
end