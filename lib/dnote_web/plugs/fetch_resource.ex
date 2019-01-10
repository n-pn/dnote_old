defmodule DnoteWeb.FetchResource do
  use DnoteWeb, :plug

  alias Dnote.{List, Note}

  def init(opts), do: opts

  def call(conn, type) when type in [:board, :label, :article, :replica] do
    account = current_user(conn)

    with name = conn.params[type],
         {:ok, data} <- get(account, type, name) do
      conn |> assign(String.to_atom("current_" <> type), data)
    else
      {:error, message} ->
        conn |> render_error(message) |> halt
    end
  end

  defp get(_, "board", nil), do: {:error, "Board not found"}
  defp get(user, "board", name), do: {:ok, List.get_board(user, name)}

  defp get(_, "label", nil), do: {:error, "Label not found"}
  defp get(user, "label", name), do: {:ok, List.get_label(user, name)}

  defp get(_, "article", nil), do: {:error, "Article not found"}
  defp get(user, "article", slug), do: {:ok, Note.get_article(user, slug)}

  defp render_error(conn, message) do
    conn
    |> render(DnoteWeb.ErrorView, "404.html", message: message)
    |> halt
  end
end
