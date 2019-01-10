defmodule Dnote.AccountController do
  use DnoteWeb, :controller

  alias Dnote.{AccountRepo, SessionRepo}

  plug DnoteWeb.AccessControl,
       "user" when action in [:edit_email, :update_email, :edit_password, :update_password]

  def new(conn, params) do
    chset = AccountRepo.changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, _account} <- AccountRepo.create(:signup, params) do
      conn
      |> put_flash(:info, "Signed up successfully.")
      |> redirect(to: Routes.session_path(:new, next: return_path(conn)))
    else
      {:error, chset} -> render(conn, "new.html", chset: chset)
    end
  end

  def edit_email(conn, params) do
    account = current_user(conn)
    chset = AccountRepo.changeset(params, account)
    render(conn, "edit_email.html", chset: chset)
  end

  def update_email(conn, %{"user" => params}) do
    account = current_user(conn)

    case AccountRepo.update(:email, account, params) do
      {:ok} ->
        conn
        |> put_flash(:info, "Email updated successfully.")
        |> redirect("/")

      {:error, chset} ->
        render(conn, "edit_email.html", chset: chset)
    end
  end

  def edit_password(conn, params) do
    account = current_user(conn)
    chset = AccountRepo.changeset(params, account)
    render(conn, "edit_password.html", chset: chset)
  end

  def update_password(conn, %{"user" => params}) do
    account = current_user(conn)

    case AccountRepo.update(:password, account, params) do
      {:ok, _} ->
        session_id = conn |> get_session("session_id")
        SessionRepo.delete_all(account, session_id)

        conn
        |> put_flash(:info, "Password updated successfully.")
        |> redirect("/")

      {:error, chset} ->
        render(conn, "edit_password.html", chset: chset)
    end
  end
end
