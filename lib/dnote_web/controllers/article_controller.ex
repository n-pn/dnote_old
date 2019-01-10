defmodule DnoteWeb.ArticleController do
  use DnoteWeb, :controller

  alias Dnote.Note

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "board" when action in [:index_board]
  plug DnoteWeb.FetchResource, "label" when action in [:index_label]
  plug DnoteWeb.FetchResource, "article" when action in [:show, :edit]

  plug DnoteWeb.ParseParams,
       [page: {:integer, 1}] when action in [:index, :index_board, :index_label]

  def index(conn, _params) do
    account = conn.assigns.current_user
    page = conn.assigns.query.page
    articles = Note.get_articles(page: page, account_id: account.id)

    render(conn, "index.html", articles: articles, action: :index)
  end

  def index_board(conn, _params) do
    board = conn.assigns.current_board
    page = conn.assigns.params.page
    articles = Note.get_articles(page: page, board_id: board.id)

    render(conn, "index.html", articles: articles, action: :board)
  end

  def index_label(conn, _params) do
    label = conn.assigns.current_label
    page = conn.assigns.params.page
    articles = Note.get_articles(page: page, label_id: label.id)

    render(conn, "index.html", articles: articles, action: :label)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
