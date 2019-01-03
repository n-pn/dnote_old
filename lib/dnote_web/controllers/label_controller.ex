defmodule Dnote.LabelController do
  use DnoteWeb, :controller

  alias Dnote.List

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "label" when action in [:show]

  plug DnoteWeb.ParseParams, [page: {:integer, 1}, query: :string] when action in [:index]

  def index(conn, _params) do
    account = conn.assigns.current_user
    labels = List.get_labels(conn.assigns.params ++ [account_id: account.id])
    render(conn, "index.html", labels: labels)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
