defmodule Bonfire.Upcycle.NeedsTest do
  use Bonfire.Upcycle.ConnDataCase

  import ValueFlows.Simulate
  import ValueFlows.Test.Faking
  import Bonfire.Me.Fake
  alias ValueFlows.Planning.Intent.Intents

  import Phoenix.LiveViewTest

  @path "/upcycle/discover"

  test "displays need" do
    agent = fake_agent!()
    account = fake_account!()
    user = fake_user!(account)

    attrs = %{
      has_point_in_time: nil,
      has_end: nil,
      provider: nil,
      name: "Lumber"
    }

    assert {:ok, intent} = Intents.create(agent, intent(attrs))

    conn = conn(user: user, account: account)

    {:ok, view, html} = live(conn, @path)

    assert has_need?(view, "Lumber")
    refute has_need?(view, "Steel")
  end

  defp has_need?(view, name) do
    has_element?(view, "[data-test-id=intent_name]", "need") and has_element?(view, "h3", name)
  end

end
