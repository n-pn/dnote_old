defmodule Dnote.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    belongs_to :account, Dnote.Account
    field :is_expired, :boolean, default: false

    field :email, :string, virtual: true
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:email, :password])
    |> update_change(:email, &String.trim/1)
    |> update_change(:password, &String.trim/1)
    |> validate_required([:email, :password])
    |> authenticate
  end

  defp authenticate(%{valid?: false} = chset), do: chset

  defp authenticate(%{changes: %{email: email, password: pass}} = chset) do
    case Dnote.Repo.get_by(Dnote.Account, email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        add_vague_error_message(chset)

      account ->
        case Pbkdf2.verify_pass(pass, account.password_encrytped) do
          true -> put_change(chset, :account, account)
          false -> add_vague_error_message(chset)
        end
    end
  end

  defp add_vague_error_message(chset) do
    add_error(chset, :email, "Email or password do not match")
  end
end
