defmodule Dnote.Writing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "writings" do
    belongs_to :account, Dnote.Account

    field :keywords, {:array, :string}, default: []
    field :keyword_ids, {:array, :integer}, default: []

    field :content, :string
    field :content_html, :string
    field :preview_data, :map

    field :status, :integer, default: 1
    field :weight, :integer, default: 0

    field :replica_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(struct, attrs, :create) do
    struct
    |> cast(attrs, [:keywords, :content])
    |> validate_required(:content)
    |> validate_input
    |> update_weight
  end

  def changeset(struct, attrs, :update) do
    struct
    |> cast(attrs, [:keywords, :content])
    |> validate_input
    |> update_weight
  end

  def changeset(struct, status, :status) do
    struct
    |> update_change(:status, status)
    |> update_weight
  end

  defp validate_input(chset) do
    chset
    |> validate_keywords
    |> validate_content
    |> put_keyword_ids
    |> render_content
  end

  defp validate_keywords(chset) do
    chset
    |> update_change(:keywords, &DnoteUtil.reject_blanks/1)
    |> validate_length(:keywords, max: 10, message: "Too many keywords (10 entries max)")
    |> validate_keywords_inner
  end

  defp validate_keywords_inner(%{valid?: false} = chset), do: chset

  defp validate_keywords_inner(%{changes: %{keywords: keywords}} = chset) do
    case keywords -- Enum.uniq(keywords) do
      [] -> Enum.reduce(keywords, chset, &validate_keyword_length(&2, &1))
      dups -> add_error(chset, :keywords, "Duplicate entries: #{inspect(dups)}")
    end
  end

  @max_length 15

  defp validate_keyword_length(chset, keyword) do
    if String.length(keyword) > @max_length do
      message = "Keyword \"#{keyword}\" too long (should be as most #{@max_length} characters)"
      add_error(chset, :keywords, message)
    else
      chset
    end
  end

  defp validate_content(chset) do
    chset
    |> validate_length(:content, min: 1, max: 20000)
  end

  defp put_keyword_ids(%{valid?: false} = chset), do: chset

  defp put_keyword_ids(%{changes: %{keywords: keywords}} = chset) do
    account_id = get_field(chset, :account_id)

    keyword_ids =
      keywords
      |> Dnote.KeywordRepo.select_or_create!(account_id)
      |> Enum.map(& &1.id)

    chset |> put_change(:keyword_ids, keyword_ids)
  end

  defp render_content(%{valid?: false} = chset), do: chset

  defp render_content(%{changes: %{content: content}} = chset) do
    content = Hmark.render(content)
    chset |> put_change(:content, content)
  end

  defp update_weight(chset) do
    status = get_field(chset, :status)
    put_change(chset, :weight, DnoteUtil.weighing(status))
  end
end
