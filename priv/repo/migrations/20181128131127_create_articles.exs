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

      add :journal_count, :integer, default: 0
      add :current_journal_id, references(:journals, on_delete: :nothing)

      timestamps()
    end

    create index(:articles, [:board_id])
    create index(:articles, [:account_id])
    create index(:articles, ["label_ids gin__int_ops"], using: "GIN")

    alter table(:journals) do
      add :article_id, references(:articles, on_delete: :nothing)
    end

    create index(:journals, [:article_id])
  end
end
