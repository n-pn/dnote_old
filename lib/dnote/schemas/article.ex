defmodule Dnote.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    belongs_to :account, Dnote.Account

    field :keyword_ids, {:array, :integer}, default: []
    field :content, :string
    field :preview, :map

    field :status, :string, default: "public"
    field :weight, :integer, default: 0

    field :replica_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:labels, :content, :preview])
    |> validate_required([:content, :preview])
  end
end
