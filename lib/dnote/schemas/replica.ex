defmodule Dnote.Replica do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replicas" do
    belongs_to :account, Dnote.Account
    belongs_to :writing, Dnote.Writing

    field :index, :integer, default: 1

    field :keyword_names, {:array, :string}
    field :content_input, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:keyword_names, :content_input])
    |> validate_keyword_names
    |> validate_content_input
  end

  defp validate_keyword_names(chset) do
    chset
    |> update_change(:keyword_names, &DnoteUtil.reject_blanks/1)
    |> validate_length(:keyword_names, max: 10, message: "Too many keywords (10 entries max)")
    |> validate_keywords_inner
  end

  defp validate_keywords_inner(%{valid?: false} = chset), do: chset

  defp validate_keywords_inner(%{changes: %{keyword_names: keywords}} = chset) do
    case keywords -- Enum.uniq(keywords) do
      [] -> Enum.reduce(keywords, chset, &validate_keyword_length(&2, &1))
      dups -> add_error(chset, :keywords, "Duplicate entries: #{inspect(dups)}")
    end
  end

  @max_length 15

  defp validate_keyword_length(chset, keyword) do
    if String.length(keyword) > @max_length do
      message = "Keyword \"#{keyword}\" too long (should be as most #{@max_length} characters)"
      add_error(chset, :keyword_names, message)
    else
      chset
    end
  end

  defp validate_content_input(chset) do
    chset
    |> validate_required([:content_input])
    |> validate_length(:content_input, min: 1, max: 20000)
  end
end
