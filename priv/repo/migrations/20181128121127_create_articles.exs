defmodule Dnote.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :board_id, references(:boards, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      add :label_ids, {:array, :integer}
      add :label_names, {:array, :citext}

      add :content, :text, null: false
      add :preview, :map, null: false

      add :status, :string, default: "public", null: false

      add :journal_count, :integer, default: 0

      timestamps()
    end

    create index(:articles, [:board_id, :status])
    create index(:articles, [:account_id, :status])
    create index(:articles, ["label_ids gin__int_ops"], using: "GIN")
  end
end
