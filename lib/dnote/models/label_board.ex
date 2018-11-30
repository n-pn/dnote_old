defmodule Dnote.LabelBoard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "label_boards" do
    belongs_to :label, Dnote.Label
    belongs_to :board, Dnote.Board

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
