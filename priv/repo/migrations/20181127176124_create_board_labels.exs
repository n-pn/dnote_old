defmodule Dnote.Repo.Migrations.CreateBoardLabels do
  use Ecto.Migration

  def change do
    create table(:board_labels) do
      add :board_id, references(:boards, on_delete: :nothing)
      add :label_id, references(:labels, on_delete: :nothing)

      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:board_labels, [:board_id, :label_id])
    create index(:board_labels, [:label_id])
  end
end
