defmodule Dnote.KeywordController do
  use DnoteWeb, :controller

  alias Dnote.KeywordRepo

  plug DnoteWeb.AccessControl, "user"
  plug DnoteWeb.FetchResource, "keyword" when action in [:show, :edit, :update, :delete]
  plug DnoteWeb.ParseParams, [page: {:integer, 1}, query: :string] when action == :index

  def index(conn, _params) do
    account = conn.assigns.current_user
    query = conn.assigns.params ++ [account_id: account.id]
    keywords = KeywordRepo.glob(query)
    render(conn, "index.html", keywords: keywords)
  end

  def new(conn, params) do
    chset = KeywordRepo.changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"keyword" => params}) do
    account = current_user(conn)

    case KeywordRepo.create(account, params) do
      {:ok, _keyword} -> redirect(conn, to: Routes.article_path(:index, []))
      {:error, chset} -> render(conn, "new.html", chset: chset)
    end
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def edit(conn, params) do
    chset = KeywordRepo.changeset(params)
    render(conn, "edit.html", chset: chset)
  end

  def update(conn, %{"keyword" => params}) do
    keyword = conn.assigns.current_keyword

    case KeywordRepo.update(keyword, params) do
      {:ok, _keyword} -> redirect(conn, to: Routes.article_path(:index, []))
      {:error, chset} -> render(conn, "edit.html", chset: chset)
    end
  end
end
