defmodule Dnote.Post do
  import Ecto.Query

  alias Dnote.{Repo, Article, Journal, Account}

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

  @limit 20
  def get_articles(params) do
    offset = (params[:page] - 1) * @limit

    from(r in Article, limit: @limit, offset: ^offset, order_by: [desc: :weight])
    |> filter_by(:account_id, params[:account_id])
    |> filter_by(:board_id, params[:board_id])
    |> filter_by(:label_ids, params[:label_ids])
    |> Repo.all()
  end

  defp filter_by(query, _, nil), do: query

  defp filter_by(query, type, value) when is_list(value) do
    from r in query, where: fragment("? @> ?", ^type, ^value)
  end

  defp filter_by(query, type, value) do
    from r in query, where: field(r, ^type) == ^value
  end
end
