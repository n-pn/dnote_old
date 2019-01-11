defmodule Dnote.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    belongs_to :account, Dnote.Account

    field :name, :string
    field :slug, :string

    field :status, :integer, default: 0
    field :weight, :integer, default: 0

    field :article_count, :integer, default: 0
    field :replica_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 15)
    |> slugify_name
    |> unique_constraint(:name, name: "keywords_unique_index")
  end

  defp slugify_name(%{valid?: false} = chset), do: chset

  defp slugify_name(%{changes: %{name: name}} = chset) do
    slug = DnoteUtil.slugify(name)
    chset |> put_change(:slug, slug)
  end
end
