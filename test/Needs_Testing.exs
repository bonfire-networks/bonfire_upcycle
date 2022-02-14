defmodule Upcycle_Ext.NeedsTesting do
  use Bonfire.Upcycle.Web.ConnCase, async: true

  import ValueFlows.Simulate
  import ValueFlows.Test.Faking

  import Phoenix.LiveViewTest

  @path "/upcycle/discover"

  test "displays need", %{conn: conn} do
    user = fake_agent!()
    intent = fake_intent!(user)

    {:ok, view, html} = live(conn, @path)

    assert has_need?(view, "Lumber")
    refute has_need?(view, "Steel")
  end

  defp has_need?(view, name) do
    has_element?(view, "[data-test-id=need]", name)
  end
