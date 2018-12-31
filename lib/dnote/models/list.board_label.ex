defmodule Dnote.BoardLabel do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "board_labels" do
    belongs_to :board, Dnote.Board
    belongs_to :label, Dnote.Label

    field :weight, :integer, default: 0
    field :article_count, :integer, default: 0

    timestamps()
  end
end
