defmodule Bonfire.Web.ViewInventoryLive do
  use Bonfire.UI.Common.Web, :live_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Me.LivePlugs
  import Bonfire.Common.Localise.Gettext
  alias ValueFlows.EconomicEvent.EconomicEvents

  def mount(params, session, socket) do
    live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(_params, _session, socket) do
    title = "View Inventory"

    # Instead of using the resolver directly, need to use a graphql query instead.
    resources = all_resources(%{}, socket)

    {:ok, socket
    |> assign(
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
      primary_accountable: "http://localhost:4000/pub/actors/developer",
    }
    extra_attrs = %{
      resource_effect: "increment",
    }

    event_res = EconomicEvents.create(current_user, event_attrs, extra_attrs)

    new_inventoried_resources = all_resources(%{}, socket)

    {:noreply, socket
    |> assign(
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
  def all_resources(params \\ %{}, socket), do: liveql(socket, :all_resources, params)

  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
