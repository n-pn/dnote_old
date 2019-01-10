defmodule Dnote.ArticleRepo do
  use Dnote, :repo

  alias Dnote.{Article, Account}

  def find(%Account{} = account, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Article, id: id, account_id: account.id)
  end

  def glob(params) do
    Article
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_contain(:keyword_ids, params[:keyword_ids])
    |> Query.paginate(params[:page])
    |> Ecto.Query.order_by(desc: :weight)
    |> Repo.all()
  end

  def create(%Account{} = account, params) do
    %Article{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def update(%Account{} = account, params) do
    %Article{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.update()
  end
end
