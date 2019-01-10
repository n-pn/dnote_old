defmodule Dnote.Note do
  use Dnote, :context

  alias Dnote.{Article, Replica, Account}

  def get_article(%Account{} = account, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Article, id: id, account_id: account.id)
  end

  def get_replica(%Account{} = account, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Replica, id: id, account_id: account.id)
  end

  def create_article(%Account{} = account, params) do
    %Article{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def update_article(%Account{} = account, params) do
    %Article{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.update()
  end

  def create_replica(%Account{} = account, params) do
    %Replica{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def get_articles(params) do
    Article
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_eq(:board_id, params[:board_id])
    |> Query.where_contain(:label_ids, params[:label_ids])
    |> Query.paginate(params[:page])
    |> order_by(desc: :weight)
    |> Repo.all()
  end

  def get_replicas(params) do
    Replica
    |> Query.where_eq(:article_id, params[:article_id])
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_eq(:board_id, params[:board_id])
    |> Query.where_contain(:label_ids, params[:label_ids])
    |> Query.paginate(params[:page])
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end
end
