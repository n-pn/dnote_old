defmodule Dnote.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :account_id, references(:accounts, on_delete: :nothing)
      add :is_expired, :boolean, default: false, null: false

      timestamps()
    end

    create index(:sessions, [:account_id])
  end
end
