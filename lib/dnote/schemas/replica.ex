defmodule Dnote.Replica do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replicas" do
    belongs_to :account, Dnote.Account
    belongs_to :article, Dnote.Article

    field :labels, {:array, :string}, default: []
    field :content, :string
    field :message, :string

    field :index, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:labels, :content, :message])
    |> validate_labels
    |> validate_content
    |> validate_length(:message, max: 250)
  end

  defp validate_labels(chset) do
    chset
    |> update_change(:labels, &DnoteUtil.reject_blanks/1)
    |> validate_length(:labels, max: 10, message: "Too many labels (10 entries max)")
    |> validate_labels_inner
  end

  defp validate_labels_inner(chset) do
    labels = chset |> get_change(:labels, [])

    case labels -- Enum.uniq(labels) do
      [] -> Enum.reduce(labels, chset, &validate_label_length(&2, &1))
      dups -> add_error(chset, :labels, "Duplicate entries: #{inspect(dups)}")
    end
  end

  @max_length 15

  defp validate_label_length(chset, label) do
    if String.length(label) > @max_length do
      message = "Label \"#{label}\" too long (should be as most #{@max_length} characters)"
      add_error(chset, :labels, message)
    else
      chset
    end
  end

  defp validate_content(chset) do
    chset
    |> validate_required([:content])
    |> validate_length(:content, min: 1, max: 20000)
  end
end
