defmodule Dnote.Repo.Migrations.CreateJournals do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :board_id, references(:boards, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      add :index, :integer, default: 0, null: false

      add :labels, {:array, :string}
      add :content, :text, null: false
      add :message, :text

      timestamps()
    end

    create index(:journals, [:board_id])
    create index(:journals, [:account_id])
  end
end
