defmodule Bonfire.Upcycle.NeedsTest do
  use Bonfire.Upcycle.ConnDataCase, async: true
  import Bonfire.Common.Simulation
  import ValueFlows.Simulate
  import ValueFlows.Test.Faking
  # import Bonfire.Me.Fake

  alias ValueFlows.Planning.Intent.Intents

  import Phoenix.LiveViewTest

  @discover "/upcycle/discover"
  @myneeds "/upcycle/my-needs"
  @schema Bonfire.API.GraphQL.Schema

  test "create a new need with attributes" do
    user = fake_agent!()
    q = create_need_mutation(fields: [receiver: [:id]])
    conn = user_conn(user)
    vars = %{intent: intent_input()}
    assert intent = grumble_post_key(q, conn, :create_need, vars)["intent"]
    assert_intent(intent)
    assert intent["receiver"]["id"] == user.id
  end

  test "displays need on discover" do
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

    {:ok, view, html} = live(conn, @discover)

    assert has_need?(view, "Lumber")
    refute has_need?(view, "Steel")
  end

  test "displays need on my needs" do
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

    {:ok, view, html} = live(conn, @myneeds)

    assert has_need?(view, "Lumber")
    refute has_need?(view, "Steel")
  end

  defp has_need?(view, name) do
    has_element?(view, "[data-test-id=intent_name]", "need") and
      has_element?(view, "h3", name)
  end
end
