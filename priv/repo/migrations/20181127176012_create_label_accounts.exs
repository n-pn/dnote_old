defmodule Dnote.Repo.Migrations.CreateLabelAccounts do
  use Ecto.Migration

  def change do
    create table(:label_accounts) do
      add :label_id, references(:labels, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:label_accounts, [:label_id, :account_id])
    create index(:label_accounts, [:account_id])
  end
end
