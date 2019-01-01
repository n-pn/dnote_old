defmodule Dnote.Query do
  import Ecto.Query

  def paginate(query, nil), do: paginate(query, 1)
  def paginate(query, page) when is_binary(page), do: paginate(query, String.to_integer(page))
  def paginate(query, page) when page < 1, do: paginate(query, 1)

  def paginate(query, page) do
    page = page - 1
    limit = 12
    offset = page * limit
    from r in query, limit: ^limit, offset: ^offset
  end

  def where_eq(query, _, nil), do: query
  def where_eq(query, type, data), do: where(query, [r], field(r, ^type) == ^data)

  def where_in(query, _, nil), do: query
  def where_in(query, type, list), do: where(query, [r], field(r, ^type) in ^list)

  def where_like(query, _, nil), do: query
  def where_like(query, type, data), do: where(query, [r], fragment("? ILIKE %?%", ^type, ^data))

  def where_contain(query, _, nil), do: query
  def where_contain(query, type, list), do: where(query, [r], fragment("? @> ?", ^type, ^list))
end
