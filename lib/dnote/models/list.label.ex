defmodule Dnote.Label do
  use Ecto.Schema
  import Ecto.Changeset

  schema "labels" do
    belongs_to :account, Dnote.Account

    field :name, :string
    field :slug, :string

    field :weight, :integer, default: 0
    field :board_count, :integer, default: 0
    field :journal_count, :integer, default: 0
    field :article_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 15)
    |> update_change(:name, &DnoteUtil.slugify/1)
    |> slugify_name
    |> unique_constraint(:name, name: "labels_unique_index")
  end

  defp slugify_name(%{valid?: false} = chset), do: chset

  defp slugify_name(%{changes: %{name: name}} = chset) do
    slug = DnoteUtil.slugify(name)
    chset |> put_change(:slug, slug)
  end
end
