defmodule Dnote.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :role, :string, default: "user", null: false

      add :email, :citext, null: false
      add :username, :citext, null: false
      add :password_encrypted, :string, null: false

      add :board_count, :integer, default: 0, null: false
      add :label_count, :integer, default: 0, null: false
      add :journal_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])
    create unique_index(:accounts, [:username])
  end
end
