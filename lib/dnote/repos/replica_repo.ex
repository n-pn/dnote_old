defmodule Dnote.ReplicaRepo do
  use Dnote, :repo

  alias Dnote.{Replica, Article}

  def find(%Article{} = article, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Replica, id: id, article_id: article.id)
  end

  def glob(params) do
    Replica
    |> Query.where_eq(:article_id, params[:article_id])
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_contain(:keywords, params[:keywords])
    |> Query.paginate(params[:page])
    |> Ecto.Query.order_by(desc: :updated_at)
    |> Repo.all()
  end

  def create(%Article{} = article, params) do
    %Replica{article_id: article.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end
end
