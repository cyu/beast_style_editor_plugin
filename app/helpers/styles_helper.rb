module StylesHelper

  def option_input_id(opt)
    "options[#{opt.name}]"
  end
  
  def option_field(option)
    s = text_field_tag("options[#{option.name}]", option.value)
    s << ' '
    if option.color?
      s << color_option_field_helper(option)
    end
    s << option_field_default(option)
    s
  end

  def color_swatch(option)
  	"<span id=\"#{option.name}_color\" style=\"padding: 0 15px; background-color: #{option.evaluated_value}; border: 1px solid #000;\"></span>"
  end

  def color_option_field_helper(option)
    s = color_swatch(option)
    s << javascript_tag("Event.observe('#{option_input_id(option)}', 'blur', function(){if($F('#{option_input_id(option)}') != '')$('#{option.name}_color').style.backgroundColor = $F('#{option_input_id(option)}')})")
    s
  end
  
  def option_field_default(option)
    s = ' <span class="entryhelp">(default: '
    s << link_to_function(option.default_value, "copyValue('#{option_input_id(option)}', '#{option.default_value}')")
    s << ')</span>'
    s
  end
  
end
