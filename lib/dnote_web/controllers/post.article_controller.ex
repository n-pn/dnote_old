defmodule DnoteWeb.ArticleController do
  use DnoteWeb, :controller

  alias Dnote.Post

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "article" when action in [:show, :edit]

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    account = conn.assigns.current_user
    articles = Post.get_articles(page: page, account_id: account.id)

    render(conn, "index.html", articles: articles, page: page)
  end

  def show(conn, _params) do
    article = conn.assigns[:current_article]
    render(conn, "show.html", article: article)
  end
end
