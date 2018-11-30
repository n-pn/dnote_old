defmodule Dnote.LabelAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "label_accounts" do
    belongs_to :label, Dnote.Label
    belongs_to :account, Dnote.Account

    field :article_count, :integer

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:article_count])
    |> validate_required([:article_count])
  end
end
