defmodule Upcycle_Ext.NeedsTesting do
  use Bonfire.Upcycle.ConnDataCase, async: true

  import ValueFlows.Simulate
  import ValueFlows.Test.Faking

  import Phoenix.LiveViewTest

  @path "/upcycle/discover"

  test "displays offer", %{conn: conn} do
    user = fake_agent!()

    test_name = "Volunteer Hours"

    attrs = %{
      provider: user.id,
      name: test_name
    }

    assert {:ok, intent} = Intents.create(user, intent(attrs))

    conn = user_conn(user)

    {:ok, view, _html} = live(conn, @path)

    assert has_offer?(view, test_name)
    refute has_offer?(view, "Definitely not the name")
  end

  defp has_offer?(view, name) do
    has_element?(view, "[data-test-id=offer]", name)
  end

end
