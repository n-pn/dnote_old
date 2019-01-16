defmodule Dnote.Replica do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replicas" do
    belongs_to :account, Dnote.Account
    belongs_to :writing, Dnote.Writing

    field :index, :integer, default: 1

    field :keyword_names, {:array, :string}
    field :content_input, :string

    timestamps()
  end
end
