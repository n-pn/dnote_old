defmodule Dnote.Label do
  use Ecto.Schema
  import Ecto.Changeset

  schema "labels" do
    belongs_to :account, Dnote.Account

    field :name, :string
    field :board_id, :id

    field :article_count, :integer

    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> update_change(:name, &DnoteUtil.slugify/1)
    |> unique_constraint(:slug)
  end
end
