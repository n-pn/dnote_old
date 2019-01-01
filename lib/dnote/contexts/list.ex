defmodule Dnote.List do
  use Dnote, :context

  alias Dnote.{Account, Board, Label, BoardLabel}

  def board_changeset(params \\ %{}, board \\ %Board{}) do
    Ecto.Changeset.change(board, params)
  end

  def get_board(account, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Board, slug: slug, account_id: account.id)
  end

  def get_label(account, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Label, slug: slug, account_id: account.id)
  end

  def get_boards(params) do
    Board
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_like(:name, params[:query])
    |> Query.paginate(params[:page])
    |> order_by(desc: :weight)
    |> Repo.all()
  end

  def get_labels(params) do
    Label
    |> Query.where_eq(:account_id, params[:account_id])
    |> Query.where_like(:name, params[:query])
    |> Query.paginate(params[:page])
    |> order_by(desc: :weight)
    |> Repo.all()
  end

  def create_board(%Account{} = account, params) do
    %Board{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def update_board(%Board{} = board, params) do
    board
    |> Ecto.Changeset.change(params)
    |> Repo.insert()
  end

  def create_label!(%Account{} = account, params) do
    %Label{account_id: account.id}
    |> Ecto.Changeset.change(params)
    |> Repo.insert!()
  end

  def find_label(%Account{} = account, label) when is_binary(label) do
    Repo.get_by(Label, account_id: account.id, slug: DnoteUtil.slugify(label))
  end

  def select_or_create_label(%Account{} = account, label) when is_binary(label) do
    case find_label(account, label) do
      nil -> create_label!(account, %{name: label})
      label -> label
    end
  end

  def select_or_create_labels(%Account{} = account, labels) when is_list(labels) do
    labels |> Enum.map(&select_or_create_label(account, &1))
  end
end
