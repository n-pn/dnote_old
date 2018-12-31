defmodule Dnote.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    belongs_to :account, Dnote.Account
    belongs_to :board, Dnote.Board

    field :label_ids, {:array, :integer}, default: []
    field :label_names, {:array, :string}, default: []

    field :content, :string
    field :preview, :map

    field :status, :string, default: "public"

    field :journal_count, :integer
    has_one :current_journal, Dnote.Journal
    has_many :journals, Dnote.Journal

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:labels, :content, :preview])
    |> validate_required([:content, :preview])
  end
end
