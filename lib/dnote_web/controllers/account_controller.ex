defmodule Dnote.AccountController do
  use DnoteWeb, :controller

  alias Dnote.User

  plug DnoteWeb.AccessControl,
       "user" when action in [:edit_email, :update_email, :edit_password, :update_password]

  def new(conn, params) do
    chset = User.account_changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, account} <- User.create_account(:signup, params),
         {:ok, session} <- User.create_session(:signup, account) do
      conn
      |> put_session("session_id", session.id)
      |> put_flash(:info, "Signed up successfully.")
      |> redirect("/")
    else
      {:error, chset} -> render(conn, "new.html", chset: chset)
    end
  end

  def edit_email(conn, params) do
    account = currennt_user(conn)
    chset = User.account_changeset(params, account)
    render(conn, "edit_email.html", chset: chset)
  end

  def update_email(conn, %{"user" => params}) do
    account = currennt_user(conn)

    case User.update_account(:email, account, params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Email updated successfully.")
        |> redirect("/")

      {:error, chset} ->
        render(conn, "edit_email.html", chset: chset)
    end
  end

  def edit_password(conn, params) do
    account = currennt_user(conn)
    chset = User.account_changeset(params, account)
    render(conn, "edit_password.html", chset: chset)
  end

  def update_password(conn, %{"user" => params}) do
    account = currennt_user(conn)

    case User.update_account(:password, account, params) do
      {:ok, account} ->
        session_id = conn |> get_session("session_id")
        User.expire_user_sessions(account, session_id)

        conn
        |> put_flash(:info, "Password updated successfully.")
        |> redirect("/")

      {:error, chset} ->
        render(conn, "edit_password.html", chset: chset)
    end
  end
end
