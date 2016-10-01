module ElmViewHelper

  def elm_embed(module_name, args = {})
    content_tag(:div) do
      component_div + script_tag(module_name, args)
    end
  end

  private

  def component_div
    content_tag(:div) {}
  end

  def script_tag(module_name, args)
    content_tag(:script, type: "text/javascript") do
      render(file: "elm/mount_script.js.erb", locals: { module_name: module_name, args: args })
    end
  end

  def encode_param(value)
    case
      when value.is_a?(String) then raw("\"#{value}\"")
      when value.is_a?(Hash) then raw(value.to_json)
      else value
    end
  end
end
