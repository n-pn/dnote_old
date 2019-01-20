defmodule Hmark.RendererTest do
  use ExUnit.Case

  test "markdown workings" do
    assert {:ok, "<p>test</p>\n"} = render("test")
  end

  @input ~s(```ruby\nputs "Hello, World!"\n```)
  @output ~s(<pre><code class=\"lang-ruby\">puts <span class=\"hljs-string\">\"Hello, World!\"</span></code></pre>\n)
  test "highlight workings" do
    assert {:ok, @output} = render(@input)
  end

  defp render(input) do
    NodeJS.call("renderer", [input])
  end
end
