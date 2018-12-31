defmodule Dnote.BoardController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "board" when action in [:show, :edit, :update, :delete]

  alias Dnote.List

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    account = conn.assigns.current_user
    boards = List.get_boards(account, page)

    render(conn, "index.html", boards: boards, page: page)
  end

  def new(conn, params) do
    chset = List.board_changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"board" => params}) do
    account = current_user(conn)

    case List.create_board(account, params) do
      {:ok, board} -> redirect(conn, to: Routes.article_path(:index_board, board.slug))
      {:error, chset} -> render(conn, "new.html", chset: chset)
    end
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def edit(conn, params) do
    chset = List.board_changeset(params)
    render(conn, "edit.html", chset: chset)
  end

  def update(conn, %{"board" => params}) do
    board = conn.assigns.current_board

    case List.update_board(board, params) do
      {:ok, board} -> redirect(conn, to: Routes.article_path(:index_board, board.slug))
      {:error, chset} -> render(conn, "edit.html", chset: chset)
    end
  end
end
