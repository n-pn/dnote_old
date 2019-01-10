defmodule Dnote.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :keyword_ids, {:array, :integer}, default: [], null: false
      add :content, :text, null: false
      add :preview, :map, null: false

      add :status, :string, default: "public", null: false
      add :weight, :integer, default: 0, null: false

      add :replica_count, :integer, default: 0, null: false

      timestamps()
    end

    create index(:articles, [:account_id, :weight])
    create index(:articles, ["keyword_ids gin__int_ops"], using: "GIN")
  end
end
