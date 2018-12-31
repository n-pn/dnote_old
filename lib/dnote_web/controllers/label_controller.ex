defmodule Dnote.LabelController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "label" when action in [:show]

  alias Dnote.List

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    account = conn.assigns.current_user
    labels = List.get_labels(account, page)
    render(conn, "index.html", labels: labels, page: page)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
