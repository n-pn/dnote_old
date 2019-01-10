defmodule Dnote.KeywordRepo do
  use Dnote, :repo

  alias Dnote.{Account, Keyword}

  def changeset(params \\ %{}, keyword \\ %Keyword{}) do
    Ecto.Changeset.change(keyword, params)
  end

  def find(account, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Keyword, slug: slug, account_id: account.id)
  end

  def glob(params) do
    Keyword
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_like(:name, params[:query])
    |> Query.paginate(params[:page])
    |> Ecto.Query.order_by(desc: :weight)
    |> Repo.all()
  end

  def select_or_create!(%Account{} = account, names) when is_list(names) do
    names |> Enum.map(&select_or_create!(account, &1))
  end

  def select_or_create!(%Account{} = account, name) when is_binary(name) do
    case find(account, name) do
      nil -> create!(account, %{name: name})
      name -> name
    end
  end

  def create(%Account{} = account, params) do
    %Keyword{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def create!(%Account{} = account, params) do
    %Keyword{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert!()
  end

  def update(%Keyword{} = keyword, params) do
    keyword
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end
end
