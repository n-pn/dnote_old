defmodule Dnote.Repo.Migrations.CreateLabelBoards do
  use Ecto.Migration

  def change do
    create table(:label_boards) do
      add :label_id, references(:labels, on_delete: :nothing)
      add :board_id, references(:boards, on_delete: :nothing)

      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:label_boards, [:label_id, :board_id])
    create index(:label_boards, [:board_id])
  end
end
