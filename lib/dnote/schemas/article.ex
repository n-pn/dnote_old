defmodule Dnote.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    belongs_to :account, Dnote.Account
    has_one :current_replica, Dnote.Replica

    field :keyword_ids, {:array, :integer}, default: []
    field :content, :string
    field :preview, :map

    field :status, :integer, default: 1
    field :weight, :integer, default: 0

    field :replica_count, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(article, replica, :create) do
    article
    |> update_weight
  end

  def changeset(article, replica, :update) do
    article
    |> update_weight
  end

  def changeset(article, status, :status) do
    article
    |> update_change(:status, status)
    |> update_weight
  end

  def update_weight(chset) do
    status = get_field(chset, :status)
    put_change(chset, :weight, DnoteUtil.weighing(status))
  end
end
