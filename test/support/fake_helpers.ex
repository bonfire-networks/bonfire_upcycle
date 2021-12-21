defmodule Bonfire.Upcycle.Test.FakeHelpers do

  alias Bonfire.Data.Identity.Account
  alias Bonfire.Upcycle.Fake
  alias Bonfire.Upcycle.Identity.{Accounts, Users}
  import ExUnit.Assertions

  import Bonfire.Upcycle.Integration

  def fake_account!(attrs \\ %{}) do
    cs = Accounts.signup_changeset(Fake.account(attrs))
    assert {:ok, account} = repo().insert(cs)
    account
  end

  def fake_user!(%Account{}=account, attrs \\ %{}) do
    assert {:ok, user} = Users.create(Fake.user(attrs), account)
    user
  end

end
