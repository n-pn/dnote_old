defmodule Dnote.AccountRepo do
  use Dnote, :repo

  alias Dnote.Account

  def get(account_id) do
    Repo.get_by(Session, id: account_id)
  end

  def changeset(params \\ %{}, account \\ %Account{}) do
    Ecto.Changeset.change(account, params)
  end

  def create(type, params) when type in [:manual, :signup] do
    %Account{}
    |> Account.changeset(params, type)
    |> Repo.insert()
  end

  def update(type, account, params) when type in [:email, :password] do
    account
    |> Account.changeset(params, type)
    |> Repo.update()
  end
end
