defmodule Dnote.ReplicaRepo do
  use Dnote, :repo

  alias Dnote.{Replica, Writing}

  def find(%Writing{} = writing, slug) do
    id = Obfus.decrypt(slug)
    Repo.get_by(Replica, id: id, writing_id: writing.id)
  end

  def glob(params) do
    Replica
    |> Query.where_eq(:writing_id, params[:writing_id])
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_contain(:keywords, params[:keywords])
    |> Query.paginate(params[:page])
    |> Ecto.Query.order_by(desc: :updated_at)
    |> Repo.all()
  end

  def create(%Writing{} = writing, params) do
    %Replica{writing_id: writing.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end
end
