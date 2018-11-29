defmodule DnoteUtil do
  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(" ", "-")
  end

  def tokenize(str) do
    str
    |> String.split(",", trim: true)
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
  end

  def reject_blanks(list) do
    list
    |> Stream.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
