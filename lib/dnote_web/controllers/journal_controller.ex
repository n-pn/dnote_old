defmodule DnoteWeb.ReplicaController do
  use DnoteWeb, :controller

  alias Dnote.Post

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "replica" when action in [:show, :edit]

  plug DnoteWeb.ParseParams, [page: [type: :integer, default: 1]] when action == :index

  def index(conn, _params) do
    account = conn.assigns.current_user
    page = conn.assigns.params.page
    replicas = Post.get_replicas(page: page, account_id: account.id)

    render(conn, "index.html", replicas: replicas, action: :index)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
