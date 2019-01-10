defmodule DnoteWeb.ArticleController do
  use DnoteWeb, :controller

  alias Dnote.ArticleRepo

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "article" when action in [:show, :edit]
  plug DnoteWeb.ParseParams, [page: {:integer, 1}] when action == :index

  def index(conn, _params) do
    account = conn.assigns.current_user
    articles = ArticleRepo.glob(conn.assigns.params ++ [account_id: account.id])
    render(conn, "index.html", articles: articles)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
