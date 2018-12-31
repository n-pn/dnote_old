defmodule Dnote.User do
  alias Dnote.{Repo, Account, Session}

  def account_changeset(params \\ %{}) do
    %Account{}
    |> Ecto.Changeset.change(params)
  end

  def session_changeset(params \\ %{}) do
    %Account{}
    |> Ecto.Changeset.change(params)
  end

  def create_account(type, params) when type in [:manual, :signup] do
    %Account{}
    |> Account.changeset(params, type)
    |> Repo.insert()
  end

  def update_password(account, params) do
    account
    |> Account.changeset(params, :password)
    |> Repo.update()
  end

  def create_session(:signup, account) do
    %Session{account_id: account.id}
    |> Repo.insert()
  end

  def create_session(:login, params) do
    %Session{}
    |> Session.changeset(params)
    |> Repo.insert()
  end

  def delete_session(session) do
    %Session{session | is_expired: true}
    |> Repo.update()
  end

  def get_session(session_id), do: Repo.get(Session, session_id)
end
