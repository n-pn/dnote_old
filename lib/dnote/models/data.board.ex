defmodule Dnote.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    belongs_to :account, Dnote.Account

    field :name, :string
    field :slug, :string
    field :desc, :string

    field :label_count, :integer
    field :journal_count, :integer
    field :article_count, :integer

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 15)
    |> update_change(:name, &DnoteUtil.slugify/1)
    |> validate_length(:desc, max: 1000)
  end
end
