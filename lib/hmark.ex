defmodule Hmark do
  def render(content) do
    content
    |> render_input()
    |> Hmark.Scrubber.scrub()
  end

  defp render_input(input) do
    NodeJS.call("renderer", [input])
  end
end
