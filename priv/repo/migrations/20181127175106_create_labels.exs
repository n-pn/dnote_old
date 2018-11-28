defmodule Dnote.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add :account_id, references(:accounts, on_delete: :nothing)

      add :name, :string, null: false
      add :slug, :citext, null: false

      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:labels, [:slug])
    create index(:labels, [:account_id])
  end
end
