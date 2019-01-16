defmodule Hmark.RendererTest do
  use ExUnit.Case

  test "calling nodejs" do
    assert {:ok, "test"} = render("test")
  end

  defp render(input) do
    NodeJS.call("renderer", [input])
  end
end
