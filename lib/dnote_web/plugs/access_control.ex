defmodule DnoteWeb.AccessControl do
  use DnoteWeb, :plug

  def init(opts), do: opts

  def call(conn, "guest") do
    if current_user(conn) do
      conn |> put_flash(:error, "Already logged in")
    else
      conn
    end
  end

  def call(conn, role) do
    case current_user(conn) do
      nil ->
        conn
        |> put_flash(:error, "You need to log in.")
        |> redirect(to: Routes.session_path(conn, :new, next: current_path(conn)))
        |> halt

      user ->
        if !check_role(user, role) do
          conn
          |> send_resp(401, "Unauthorized")
          |> halt
        else
          conn
        end
    end
  end

  defp check_role(user, "user"), do: check_role(user, ["member", "admin"])
  defp check_role(user, role) when is_binary(role), do: user.role == role
  defp check_role(user, roles) when is_list(roles), do: user.role in roles
end
