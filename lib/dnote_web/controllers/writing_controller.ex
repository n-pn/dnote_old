defmodule DnoteWeb.WritingController do
  use DnoteWeb, :controller

  alias Dnote.WritingRepo

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "writing" when action in [:show, :edit]
  plug DnoteWeb.ParseParams, {"p", :integer, 1, :page} when action == :index

  def index(conn, _params) do
    account = conn.assigns.current_user
    writings = WritingRepo.glob(conn.assigns.params ++ [account_id: account.id])
    render(conn, "index.html", writings: writings)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
