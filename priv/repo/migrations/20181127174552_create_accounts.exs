defmodule Dnote.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :role, :string, default: "user", null: false

      add :email, :citext, null: false
      add :password_encrypted, :string, null: false

      add :keyword_count, :integer, default: 0, null: false
      add :article_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end
end
