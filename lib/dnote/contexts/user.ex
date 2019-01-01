defmodule Dnote.User do
  use Dnote, :context
  alias Dnote.{Account, Session}

  def account_changeset(params \\ %{}, account \\ %Account{}) do
    Ecto.Changeset.change(account, params)
  end

  def session_changeset(params \\ %{}, session \\ %Session{}) do
    Ecto.Changeset.change(session, params)
  end

  def create_account(type, params) when type in [:manual, :signup] do
    %Account{}
    |> Account.changeset(params, type)
    |> Repo.insert()
  end

  def update_account(type, account, params) when type in [:email, :password] do
    account
    |> Account.changeset(params, type)
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

  def delete_session(session_id) do
    from(r in Session, where: r.id == ^session_id)
    |> Repo.update_all(set: [is_expired: true])
  end

  def get_session(session_id) do
    Repo.get_by(Session, id: session_id, is_expired: false)
    |> Repo.preload(:account)
  end

  def expire_user_sessions(account, session_id \\ 0) do
    from(r in Session, where: r.account_id == ^account.id, where: r.id != ^session_id)
    |> Repo.update_all(set: [is_expired: true])
  end
end
