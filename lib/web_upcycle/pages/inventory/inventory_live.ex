defmodule Bonfire.Upcycle.Web.InventoryLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}
  alias Bonfire.Web.LivePlugs

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  prop action, :any, default: "raise"

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(params, session, socket) do
    current_user = current_user(socket)
    resources = resources(socket).myAgent.inventoriedEconomicResources

    {:ok, socket
    |> assign(
      user: current_user,
      resources: resources,
      changeset: ValueFlows.EconomicEvent.validate_changeset(),
      action: "raise"
    )}
  end

  @graphql """
  query {
    myAgent {
      inventoriedEconomicResources {
        id
        name
        note
        image
        conformsTo{
          id
          name
        }
        primaryAccountable {
          displayUsername
          name
          image
        }
        onhandQuantity {
          hasNumericalValue
          hasUnit {
            label
            symbol
          }
        }
        conformsTo {
          name
        }
        currentLocation {
          displayUsername
          canonicalUrl
        }
      }
    }
  }
  """
  def resources(params \\ %{}, socket), do: liveql(socket, :resources, params)

  def handle_event("toggle_action", %{"id" => id}, socket) do
    debug(id)
    {:noreply,
      socket |> assign(action: id)}
  end

  @spec handle_event(any, any, any) :: {any, any} | {:ok, any, any} | {:reply, any, any}
  def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
