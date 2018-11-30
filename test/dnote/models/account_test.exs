defmodule Dnote.AccountTest do
  use Dnote.DataCase

  alias Dnote.Account

  @valids [
    "email@example.com",
    "firstname.lastname@example.com",
    "email@subdomain.example.com",
    "firstname+lastname@example.com",
    "email@123.123.123.123",
    "email@[123.123.123.123]",
    "\"email\"@example.com",
    "1234567890@example.com",
    "email@example-one.com",
    "_______@example.com",
    "email@example.name",
    "email@example.museum",
    "email@example.co.jp",
    "firstname-lastname@example.com",
    "much.”more\ unusual”@example.com",
    "very.unusual.”@”.unusual.com@example.com",
    "very.”(),:;<>[]”.VERY.”very@\\\\ \"very”.unusual@strange.example.com"
  ]

  test "valid email formats" do
    for email <- @valids do
      chset = email_changeset(email)
      assert %{valid?: true} = chset
    end
  end

  @invalids [
    "plainaddress",
    "plainaddress@",
    "plainaddress@  ",
    "@plainaddress",
    "  @plainaddress"
  ]

  test "invalid email formats" do
    for email <- @invalids do
      chset = email_changeset(email)
      assert %{valid?: false} = chset
      assert "has invalid format" in errors_on(chset).email
    end
  end

  def email_changeset(email) do
    changeset(%{
      email: email,
      username: "username",
      password: "password",
      password_confirmation: "password"
    })
  end

  defp changeset(params) do
    Account.changeset(%Account{}, params)
  end
end
