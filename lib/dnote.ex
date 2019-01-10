defmodule Dnote do
  @moduledoc """
  Dnote keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def repo do
    quote do
      alias Dnote.{Repo, Query}
      import Ecto.Query

      alias DnoteUtil, as: Util
    end
  end

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      alias DnoteUtil, as: Util
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
