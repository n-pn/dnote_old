defmodule Dnote.ExploreController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"

  alias Dnote.{List, Post}

  def index(conn, _params) do
    account = conn.assigns.current_user
    boards = List.get_boards(account, 1)
    labels = List.get_labels(account, 1)
    articles = Post.get_articles(page: 1, account_id: account.id)

    render(conn, "index.html", boards: boards, labels: labels, articles: articles)
  end
end
