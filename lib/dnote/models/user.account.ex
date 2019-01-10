defmodule Dnote.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :role, :string, default: "user"

    field :email, :string
    field :username, :string
    field :password_encrypted, :string

    field :board_count, :integer, default: 0
    field :label_count, :integer, default: 0
    field :replica_count, :integer, default: 0
    field :article_count, :integer, default: 0

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :old_password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(model, attrs, :manual) do
    model
    |> cast(attrs, [:role, :email, :username, :password])
    |> validate_email
    |> validate_username
    |> encrypt_password
  end

  def changeset(model, attrs, :signup) do
    model
    |> cast(attrs, [:email, :username, :password, :password_confirmation])
    |> validate_email
    |> validate_username
    |> validate_password
  end

  def changeset(model, attrs, :email) do
    model
    |> cast(attrs, [:email, :old_password])
    |> validate_email
    |> validate_old_password
  end

  def changeset(model, attrs, :password) do
    model
    |> cast(attrs, [:old_password, :password, :password_confirmation])
    |> validate_password
    |> validate_old_password
  end

  @email_format ~r/.+@.+\..+/
  defp validate_email(chset) do
    chset
    |> update_change(:email, &String.trim/1)
    |> validate_required(:email)
    |> validate_format(:email, @email_format)
    |> validate_length(:email, min: 3, max: 100)
    |> unique_constraint(:email)
  end

  @username_format ~r/^[\w-.]+$/u
  defp validate_username(chset) do
    chset
    |> update_change(:username, &String.trim/1)
    |> validate_required(:username)
    |> validate_length(:username, min: 3, max: 20)
    |> validate_format(:username, @username_format)
    |> unique_constraint(:username)
  end

  defp validate_password(chset) do
    chset
    |> update_change(:password, &String.trim/1)
    |> validate_required(:password)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> encrypt_password
  end

  defp validate_old_password(chset) do
    chset
    |> validate_required(:old_password)
    |> check_old_password
  end

  defp check_old_password(%{valid?: false} = chset), do: chset

  defp check_old_password(%{changes: %{old_password: pass}} = chset) do
    password_encrypted = chset |> get_field(:password_encrypted)

    if Pbkdf2.verify_pass(pass, password_encrypted) do
      chset |> add_error(:old_password, "Old passsword doesn't match")
    else
      chset
    end
  end

  defp encrypt_password(%{valid?: false} = chset), do: chset

  defp encrypt_password(%{changes: %{password: pass}} = chset) do
    password_encrypted = Pbkdf2.hash_pwd_salt(pass)
    put_change(chset, :password_encrypted, password_encrypted)
  end
end
