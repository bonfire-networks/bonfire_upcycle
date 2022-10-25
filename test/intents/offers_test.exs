defmodule Bonfire.Upcycle.OffersTest do
  use Bonfire.Upcycle.ConnDataCase, async: true
  import Bonfire.Common.Simulation
  import ValueFlows.Simulate
  import ValueFlows.Test.Faking
  # import Bonfire.Me.Fake
  alias ValueFlows.Planning.Intent.Intents

  import Phoenix.LiveViewTest

  @schema Bonfire.API.GraphQL.Schema

  @discover "/upcycle/discover"
  @myoffers "/upcycle/my-offers"

  test "creates a new offer with attributes" do
    user = fake_agent!()
    q = create_offer_mutation(fields: [provider: [:id]])
    conn = user_conn(user)
    vars = %{intent: intent_input()}
    assert intent = grumble_post_key(q, conn, :create_offer, vars)["intent"]
    assert_intent(intent)
    assert intent["provider"]["id"] == user.id
  end

  test "displays offer on discover" do
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

    {:ok, view, _html} = live(conn, @discover)

    assert has_offer?(view, test_name)
    refute has_offer?(view, "Definitely not the name")
  end

  test "displays offer on my offers" do
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

    {:ok, view, _html} = live(conn, @myoffers)

    assert has_offer?(view, test_name)
    refute has_offer?(view, "Definitely not the name")
  end

  defp has_offer?(view, name) do
    has_element?(view, "[data-test-id=intent_name]", "offer") and
      has_element?(view, "h3", name)
  end
end
