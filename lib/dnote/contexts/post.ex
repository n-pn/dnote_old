defmodule Dnote.Post do
  use Dnote, :context

  alias Dnote.{Article, Journal, Account}

  def get_article(%Account{} = account, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Article, id: id, account_id: account.id)
  end

  def get_journal(%Account{} = account, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Journal, id: id, account_id: account.id)
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

  def create_journal(%Account{} = account, params) do
    %Journal{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def get_articles(params) do
    from(r in Article, order_by: [desc: :weight])
    |> Query.paginate(params[:page])
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_eq(:board_id, params[:board_id])
    |> Query.where_contain(:label_ids, params[:label_ids])
    |> Repo.all()
  end
end
