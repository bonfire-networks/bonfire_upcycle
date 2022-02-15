defmodule Upcycle_Ext.NeedsTesting do
  use Bonfire.Upcycle.ConnCase, async: true

  import ValueFlows.Simulate
  import ValueFlows.Test.Faking

  import Phoenix.LiveViewTest

  @path "/upcycle/discover"

  test "displays need" do
    user = fake_agent!()

    attrs = %{
      provider: user.id,
      name: "Lumber"
    }

    assert {:ok, intent} = Intents.create(user, intent(attrs))

    conn = user_conn(user)

    {:ok, view, html} = live(conn, @path)

    assert has_need?(view, "Lumber")
    refute has_need?(view, "Steel")
  end

  defp has_need?(view, name) do
    has_element?(view, "[data-test-id=intent_name]", name)
  end

end
