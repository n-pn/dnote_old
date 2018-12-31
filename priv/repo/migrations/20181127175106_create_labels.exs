defmodule Dnote.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :name, :string, null: false
      add :slug, :citext, null: false

      add :weight, :integer, default: 0, null: false
      add :board_count, :integer, default: 0, null: false
      add :journal_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:labels, [:account_id, :slug], name: "labels_unique_index")
    create index(:labels, [:account_id, :weight])
  end
end
