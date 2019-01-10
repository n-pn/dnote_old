defmodule Dnote.HomeController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"

  alias Dnote.{List, Note}

  def index(conn, _params) do
    account = conn.assigns.current_user
    boards = List.get_boards(account_id: account.id)
    labels = List.get_labels(account_id: account.id)
    articles = Note.get_articles(account_id: account.id)

    render(conn, "index.html", boards: boards, labels: labels, articles: articles)
  end
end
