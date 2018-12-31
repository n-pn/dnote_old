defmodule Dnote.AccountController do
  use DnoteWeb, :controller

  alias Dnote.User

  def new(conn, params) do
    chset = User.account_changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, account} <- User.create_account(:signup, params),
         {:ok, session} <- User.create_session(:signup, account) do
      conn
      |> put_session(:session_id, session.id)
      |> put_flash(:info, "Signed up successfully.")
      |> redirect("/")
    else
      {:error, chset} -> render(conn, "new.html", chset: chset)
    end
  end
end
