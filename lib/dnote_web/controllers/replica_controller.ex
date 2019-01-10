defmodule DnoteWeb.ReplicaController do
  use DnoteWeb, :controller

  alias Dnote.ReplicaRepo

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "article" when action == :index
  plug DnoteWeb.FetchResource, "replica" when action == :show

  plug DnoteWeb.ParseParams, [page: [type: :integer, default: 1]] when action == :index

  def index(conn, _params) do
    article = conn.assigns.current_user
    replicas = ReplicaRepo.glob(conn.assigns.params ++ [article_id: article.id])
    render(conn, "index.html", replicas: replicas)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
