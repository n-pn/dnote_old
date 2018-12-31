defmodule Dnote.LabelController do
  use DnoteWeb, :controller

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "label" when action in [:show]

  alias Dnote.{List, Post}

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    account = conn.assigns.current_user
    labels = List.get_labels(account, page)

    render(conn, "index.html", labels: labels, page: page)
  end

  def show(conn, params) do
    label = conn.assigns[:current_label]
    page = Map.get(params, "page", "1") |> DnoteUtil.parse_int()
    articles = Post.get_articles(page: page, label_id: label.id)

    render(conn, "show.html", page: page, articles: articles)
  end
end
