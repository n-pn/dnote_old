defmodule DnoteWeb.ParseParams do
  use DnoteWeb, :plug

  def init(opts), do: opts

  def call(conn, opts) when is_tuple(opts), do: parse(conn, opts)

  def call(conn, opts) when is_list(opts) do
    params = opts |> Stream.map(&parse(conn, &1)) |> Enum.reject(&is_nil(&1))
    conn |> assign(:params, params)
  end

  defp parse(conn, {name, type}), do: parse(conn, {name, type, nil})

  defp parse(conn, {name, type, default}),
    do: parse(conn, {name, type, default, String.to_atom(name)})

  defp parse(conn, {name, type, default, atom}) do
    case cast(type, conn.params[name], default) do
      nil -> nil
      value -> {atom, value}
    end
  end

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
