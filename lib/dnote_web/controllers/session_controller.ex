defmodule Dnote.SessionController do
  use DnoteWeb, :controller

  alias Dnote.User

  plug DnoteWeb.AccessControl, "user" when action in [:destroy]

  def new(conn, params) do
    chset = User.session_changeset(params)
    render(conn, "new.html", chset: chset)
  end

  def create(conn, %{"user" => params}) do
    case User.create_session(:login, params) do
      {:ok, session} ->
        conn
        |> put_session("session_id", session.id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect("/")

      {:error, chset} ->
        render(conn, "new.html", chset: chset)
    end
  end

  def destroy(conn, _params) do
    session_id = conn |> get_session("session_id")

    User.delete_session(session_id)

    conn
    |> put_flash(:info, "Logged out successfully.")
    |> redirect("/")
  end
end
