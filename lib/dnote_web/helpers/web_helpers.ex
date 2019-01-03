defmodule DnoteWeb.WebHelpers do
  def current_user(conn), do: conn.assigns[:current_user]
  def logged_in?(conn), do: !!current_user(conn)
  def return_path(conn), do: conn.params["next"] || "/"
end
