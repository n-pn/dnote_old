defmodule Dnote.BoardController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "board" when action in [:show, :edit, :update, :delete]

  alias Dnote.{List, Post}

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    account = conn.assigns.current_user
    boards = List.get_boards(account, page)

    render(conn, "index.html", boards: boards, page: page)
  end

  def show(conn, params) do
    board = conn.assigns[:current_board]
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    articles = Post.get_articles(page: page, board_id: board.id)

    render(conn, "show.html", page: page, articles: articles)
  end
end
