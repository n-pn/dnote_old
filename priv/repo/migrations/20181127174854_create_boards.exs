defmodule Dnote.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :name, :string, null: false
      add :slug, :citext, null: false
      add :desc, :text

      add :weight, :integer, default: 0, null: false
      add :label_count, :integer, default: 0, null: false
      add :replica_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:boards, [:account_id, :slug], name: "boards_unique_index")
    create index(:boards, [:account_id, :weight])
  end
end
