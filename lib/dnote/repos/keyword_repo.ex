defmodule Dnote.KeywordRepo do
  use Dnote, :repo

  alias Dnote.{Account, Keyword}

  def changeset(params \\ %{}, keyword \\ %Keyword{}) do
    Ecto.Changeset.change(keyword, params)
  end

  def find(%Account{} = account, name) do
    find(account.id, name)
  end

  def find(account_id, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Keyword, slug: slug, account_id: account_id)
  end

  def glob(params) do
    Keyword
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_like(:name, params[:query])
    |> Query.paginate(params[:page])
    |> Ecto.Query.order_by(desc: :weight)
    |> Repo.all()
  end

  def select_or_create!(%Account{} = account, opts) do
    select_or_create!(account.id, opts)
  end

  def select_or_create!(account_id, names) when is_list(names) do
    names |> Enum.map(&select_or_create!(account_id, &1))
  end

  def select_or_create!(account_id, name) when is_binary(name) do
    case find(account_id, name) do
      nil -> create!(account_id, %{name: name})
      name -> name
    end
  end

  def create(%Account{} = account, params) do
    create(account.id, params)
  end

  def create(account_id, params) do
    %Keyword{account_id: account_id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def create!(account_id, params) do
    %Keyword{account_id: account_id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert!()
  end

  def update(%Keyword{} = keyword, params) do
    keyword
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end
end
