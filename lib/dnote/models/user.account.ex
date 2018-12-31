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
    field :journal_count, :integer, default: 0
    field :article_count, :integer, default: 0

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @fields [:email, :username, :password, :password_confirmation]

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, @fields)
    |> validate_email
    |> validate_username
    |> validate_password
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

  defp encrypt_password(%{valid?: false} = chset), do: chset

  defp encrypt_password(%{changes: %{password: pass}} = chset) do
    password_encrypted = Pbkdf2.hash_pwd_salt(pass)
    put_change(chset, :password_encrypted, password_encrypted)
  end
end
