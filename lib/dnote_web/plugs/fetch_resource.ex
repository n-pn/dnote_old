defmodule DnoteWeb.FetchResource do
  use DnoteWeb, :plug

  alias Dnote.{WritingRepo, KeywordRepo}

  def init(opts), do: opts

  def call(conn, type) when type in ["keyword", "writing", "replica"] do
    account = current_user(conn)

    with name = conn.params[type],
         {:ok, data} <- get(account, type, name) do
      conn |> assign(String.to_atom("current_" <> type), data)
    else
      {:error, message} ->
        conn |> render_error(message) |> halt
    end
  end

  defp get(_, "keyword", nil), do: {:error, "Keyword not found"}
  defp get(account, "keyword", name), do: {:ok, KeywordRepo.find(account, name)}

  defp get(_, "writing", nil), do: {:error, "Writing not found"}
  defp get(account, "writing", slug), do: {:ok, WritingRepo.find(account, slug)}

  defp render_error(conn, message) do
    conn
    |> render(DnoteWeb.ErrorView, "404.html", message: message)
    |> halt
  end
end
