defmodule Dnote.Writing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "writings" do
    belongs_to :account, Dnote.Account

    field :keyword_names, {:array, :string}, default: []
    field :content_input, :string

    field :keyword_ids, {:array, :integer}, default: []
    field :content, :string
    field :preview, :map

    field :status, :integer, default: 1
    field :weight, :integer, default: 0

    field :replica_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(writing, replica, :create) do
    writing
    |> update_weight
  end

  def changeset(writing, replica, :update) do
    writing
    |> update_weight
  end

  def changeset(writing, status, :status) do
    writing
    |> update_change(:status, status)
    |> update_weight
  end

  def update_weight(chset) do
    status = get_field(chset, :status)
    put_change(chset, :weight, DnoteUtil.weighing(status))
  end
end
