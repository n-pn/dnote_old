defmodule DnoteUtil do
  @epoch ~N[2019-01-01 00:00:00]

  def time_diff(current \\ NaiveDateTime.utc_now(), previous \\ @epoch) do
    NaiveDateTime.diff(current, previous)
  end

  @one_year_in_minutes 525_600
  def weighing(status, count), do: weighing(status) + count
  def weighing(status), do: weighing() + status * @one_year_in_minutes
  def weighing, do: div(time_diff(), 60)

  def parse_int(str) do
    String.to_integer(str)
  end

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
