defmodule Dnote.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :name, :string, null: false
      add :slug, :citext, null: false

      add :status, :integer, default: 0, null: false
      add :weight, :integer, default: 0, null: false

      add :replica_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:keywords, [:slug, :account_id], name: "keywords_unique_index")
    create index(:keywords, [:account_id, :weight])
  end
end
