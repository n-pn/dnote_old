defmodule DnoteWeb.IdentifyUser do
  import Plug.Conn

  alias Dnote.SessionRepo

  def init(opts), do: opts

  def call(conn, _opts) do
    with session_id = get_session(conn, "session_id"),
         {:ok, session} <- find_session(session_id) do
      conn |> assign(:current_user, session.account)
    else
      {:error, _message} -> conn
    end
  end

  defp find_session(nil), do: {:error, "No session"}
  defp find_session(id), do: {:ok, SessionRepo.get(id)}
end
