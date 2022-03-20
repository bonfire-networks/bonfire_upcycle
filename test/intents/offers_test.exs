defmodule Bonfire.Upcycle.OffersTest do
  use Bonfire.Upcycle.ConnDataCase, async: true

  import ValueFlows.Simulate
  import ValueFlows.Test.Faking
  import Bonfire.Me.Fake
  alias ValueFlows.Planning.Intent.Intents

  import Phoenix.LiveViewTest

  @path "/upcycle/discover"

  test "displays offer" do
    agent = fake_agent!()
    account = fake_account!()
    user = fake_user!(account)

    test_name = "Volunteer Hours"

    attrs = %{
      has_point_in_time: nil,
      has_end: nil,
      provider: agent.id,
      name: test_name
    }

    assert {:ok, intent} = Intents.create(agent, intent(attrs))

    conn = conn(user: user, account: account)

    {:ok, view, _html} = live(conn, @path)

    assert has_offer?(view, test_name)
    refute has_offer?(view, "Definitely not the name")
  end

  defp has_offer?(view, name) do
    has_element?(view, "[data-test-id=intent_name]", "offer") and has_element?(view, "h3", name)
  end

end
