defmodule Dnote.Journal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journals" do
    belongs_to :board, Dnote.Board
    belongs_to :account, Dnote.Account
    belongs_to :article, Dnote.Article

    field :index, :integer

    field :labels, {:array, :string}, default: []
    field :content, :string
    field :message, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:labels, :content, :message])
    |> update_change(:labels, &DnoteUtil.reject_blanks/1)
    |> validate_length(:labels, max: 10, message: "Too many labels (10 entries max)")
    |> validate_unique_labels
    |> validate_label_lengths
    |> validate_required([:content])
    |> validate_length(:content, min: 1, max: 20000)
    |> validate_length(:message, max: 250)
  end

  defp validate_unique_labels(%{changes: %{labels: labels}} = chset) do
    case labels -- Enum.uniq(labels) do
      [] -> chset
      dups -> add_error(chset, :labels, "Duplicate entries: #{inspect(dups)}")
    end
  end

  defp validate_unique_labels(chset), do: chset

  defp validate_label_lengths(%{changes: %{labels: labels}} = chset) do
    Enum.reduce(labels, chset, &validate_label_length(&2, &1))
  end

  defp validate_label_lengths(chset), do: chset

  @max_length 15

  defp validate_label_length(chset, label) do
    if String.length(label) <= @max_length do
      chset
    else
      chset
      |> add_error(
        :labels,
        "Label \"#{label}\" too long (each label should be as most #{@max_length} characters)"
      )
    end
  end
end
