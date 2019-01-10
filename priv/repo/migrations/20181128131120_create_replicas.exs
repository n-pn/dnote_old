defmodule Dnote.Repo.Migrations.CreateReplicas do
  use Ecto.Migration

  def change do
    create table(:replicas) do
      add :account_id, references(:accounts, on_delete: :nothing)
      add :article_id, references(:articles, on_delete: :nothing)

      add :keywords, {:array, :string}
      add :content, :text, null: false

      add :index, :integer, default: 0, null: false
      add :status, :string, default: "draft", null: false

      timestamps()
    end

    create index(:replicas, [:account_id])
    create index(:replicas, [:article_id])

    # alter table(:articles) do
    #   add :current_replica_id, references(:replicas, on_delete: :nothing)
    # end
  end
end
