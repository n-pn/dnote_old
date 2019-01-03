defmodule DnoteWeb.ViewHelpers do
  use Phoenix.HTML

  def field_message(form, field, default \\ nil) do
    case Keyword.get_values(form.errors, field) do
      [] -> content_tag(:div, default, class: "field-message _info")
      [error | _] -> content_tag(:div, error, class: "field-message _error")
    end
  end
end
