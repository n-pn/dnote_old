defmodule Dnote.List do
  import Ecto.Query

  alias Dnote.{Repo, Account, Board, Label, BoardLabel}

  def board_changeset(params) do
    %Board{}
    |> Ecto.Changeset.change(params)
  end

  def get_board(account, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Board, slug: slug, account_id: account.id)
  end

  def get_label(account, name) do
    slug = DnoteUtil.slugify(name)
    Repo.get_by(Label, slug: slug, account_id: account.id)
  end

  @limit 20
  def get_boards(account, page \\ 1) do
    offset = (page - 1) * @limit

    from(r in Board, where: r.account_id == ^account.id, limit: @limit, offset: ^offset)
    |> Repo.all()
  end

  def get_labels(account, page \\ 1) do
    offset = (page - 1) * @limit

    from(r in Label, where: r.account_id == ^account.id, limit: @limit, offset: ^offset)
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
