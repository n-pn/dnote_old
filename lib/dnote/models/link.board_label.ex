defmodule Dnote.BoardLabel do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "board_labels" do
    belongs_to :board, Dnote.Board
    belongs_to :label, Dnote.Label

    field :article_count, :integer

    timestamps()
  end
end
