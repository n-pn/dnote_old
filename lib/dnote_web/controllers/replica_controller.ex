defmodule DnoteWeb.ReplicaController do
  use DnoteWeb, :controller

  alias Dnote.ReplicaRepo

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "writing" when action == :index
  plug DnoteWeb.FetchResource, "replica" when action == :show

  plug DnoteWeb.ParseParams, [page: [type: :integer, default: 1]] when action == :index

  def index(conn, _params) do
    writing = conn.assigns.current_user
    replicas = ReplicaRepo.glob(conn.assigns.params ++ [writing_id: writing.id])
    render(conn, "index.html", replicas: replicas)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
