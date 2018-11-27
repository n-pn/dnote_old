defmodule Dnote.Repo do
  use Ecto.Repo,
    otp_app: :dnote,
    adapter: Ecto.Adapters.Postgres
end
