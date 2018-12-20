defmodule Dnote.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :name, :string, null: false
      add :slug, :string, null: false
      add :desc, :text

      add :label_count, :integer, default: 0, null: false
      add :journal_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create index(:boards, [:account_id])
  end
end
