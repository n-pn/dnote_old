defmodule Dnote.SessionRepo do
  use Dnote, :repo
  alias Dnote.{Session, Account}

  def get(session_id) do
    Repo.get_by(Session, id: session_id, is_expired: false)
    |> Repo.preload(:account)
  end

  def changeset(params \\ %{}, session \\ %Session{}) do
    Ecto.Changeset.change(session, params)
  end

  def create(:signup, %Account{} = account) do
    %Session{account_id: account.id}
    |> Repo.insert()
  end

  def create(:login, params) do
    %Session{}
    |> Session.changeset(params)
    |> Repo.insert()
  end

  def delete(session_id) do
    from(r in Session, where: r.id == ^session_id)
    |> Repo.update_all(set: [is_expired: true])
  end

  def delete_all(account, keep_session_id \\ 0) do
    from(r in Session, where: r.account_id == ^account.id, where: r.id != ^keep_session_id)
    |> Repo.update_all(set: [is_expired: true])
  end
end
