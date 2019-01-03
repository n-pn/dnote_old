defmodule DnoteWeb.ParseParams do
  use DnoteWeb, :plug

  def init(opts), do: opts

  def call(conn, list) do
    params = list |> Enum.map(&parse_param(conn, &1)) |> Enum.reject(&is_nil(&1))
    conn |> assign(:params, params)
  end

  defp parse_param(conn, {key, type}) when is_atom(type) do
    case cast(type, fetch_data(conn, key), nil) do
      nil -> nil
      value -> {key, value}
    end
  end

  defp parse_param(conn, {key, {type, default}}) do
    case cast(type, fetch_data(conn, key), default) do
      nil -> nil
      value -> {key, value}
    end
  end

  defp fetch_data(conn, key), do: conn.params[Atom.to_string(key)]

  defp cast(_, nil, default), do: default
  defp cast(:integer, data, default), do: parse_int(data, default)
  defp cast(:boolean, "true", _), do: true
  defp cast(:boolean, "false", _), do: false
  defp cast(:boolean, _, default), do: default
  defp cast(:atom, data, _), do: String.to_atom(data)

  defp parse_int(str, default) do
    try do
      String.to_integer(str)
    rescue
      ArgumentError -> default
    end
  end
end
