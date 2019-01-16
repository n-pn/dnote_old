defmodule Dnote.Repo.Migrations.CreateReplicas do
  use Ecto.Migration

  def change do
    create table(:replicas) do
      add :account_id, references(:accounts, on_delete: :nothing)
      add :writing_id, references(:writings, on_delete: :nothing)

      add :index, :integer, default: 0, null: false

      add :keywords, {:array, :string}, default: [], null: false
      add :content, :text, null: false

      timestamps()
    end

    create index(:replicas, [:account_id])
    create index(:replicas, [:writing_id])

    # alter table(:articles) do
    #   add :replica_id, references(:replicas, on_delete: :nothing)
    # end
  end
end
