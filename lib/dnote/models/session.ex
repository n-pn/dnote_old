defmodule Dnote.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :is_expired, :boolean, default: false
    field :account_id, :id

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

  defp authenticate(%{valid?: true, changes: %{email: email, password: password}} = chset) do
    case Dnote.Repo.get_by(Dnote.Account, email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        chset |> add_login_error_message

      account ->
        if Pbkdf2.verify_pass(password, account.password_encrypted) do
          chset |> put_change(:account_id, account.id)
        else
          chset |> add_login_error_message
        end
    end
  end

  defp authenticate(chset), do: chset

  defp add_login_error_message(chset) do
    chset |> add_error(:email, "Email or password do not match")
  end
end
