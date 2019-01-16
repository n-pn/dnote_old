defmodule Dnote.Repo.Migrations.CreateWritings do
  use Ecto.Migration

  def change do
    create table(:writings) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :keywords, {:array, :citext}, default: [], null: false
      add :keyword_ids, {:array, :integer}, default: [], null: false

      add :content, :text, null: false
      add :content_html, :text, null: false
      add :preview_data, :map, null: false

      add :status, :integer, default: 1, null: false
      add :weight, :integer, default: 0, null: false

      add :replica_count, :integer, default: 0, null: false

      timestamps()
    end

    create index(:writings, [:account_id, :weight])
    create index(:writings, ["keyword_ids gin__int_ops"], using: "GIN")
  end
end
