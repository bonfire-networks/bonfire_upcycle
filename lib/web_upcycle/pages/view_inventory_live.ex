defmodule Bonfire.Web.ViewInventoryLive do
  use Bonfire.UI.Common.Web, :live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias ValueFlows.EconomicEvent.EconomicEvents

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "View Inventory"

    # Instead of using the resolver directly, need to use a graphql query instead.
    resources = all_resources(%{}, socket)

    {:ok,
     assign(
       socket,
       page_title: title,
       feed_title: title,
       inventoried_resources: resources,
       without_sidebar: true
     )}
  end

  def handle_event("create_mock", _attrs, socket) do
    # mock_resource = GraphQL.simulate({}, {})
    # IO.inspect(mock_resource)

    current_user = socket.assigns.current_user

    event_attrs = %{
      action: "raise",
      # Here, the note on the event doubles as the resource name.
      note: "Name of Resource",
      resource_note: "This is a note on the resource.",
      primary_accountable: "http://localhost:4000/pub/actors/developer"
    }

    extra_attrs = %{
      resource_effect: "increment"
    }

    event_res = EconomicEvents.create(current_user, event_attrs, extra_attrs)

    new_inventoried_resources = all_resources(%{}, socket)

    {:noreply,
     assign(socket,
       inventoried_resources: new_inventoried_resources
     )}
  end

  # TODO: change this as needed to only get the current user's inventory
  @graphql """
  {
    agents {
      name
      inventoried_economic_resources {
        name
        note
      }
    }
  }
  """
  def all_resources(params \\ %{}, socket),
    do: liveql(socket, :all_resources, params)
end
