defmodule Bonfire.Upcycle.Web.InventoryLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  alias Bonfire.UI.Me.LivePlugs

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  def mount(params, session, socket),
    do:
      live_plug(params, session, socket, [
        LivePlugs.LoadCurrentAccount,
        LivePlugs.LoadCurrentUser,
        Bonfire.UI.Common.LivePlugs.StaticChanged,
        Bonfire.UI.Common.LivePlugs.Csrf,
        Bonfire.UI.Common.LivePlugs.Locale,
        &mounted/3
      ])

  defp mounted(params, session, socket) do
    current_user = current_user(socket)
    resources = resources(socket).myAgent.inventoriedEconomicResources

    {:ok,
     assign(
       socket,
       user: current_user,
       resources: resources,
       changeset: ValueFlows.EconomicEvent.validate_changeset(),
       action: "raise",
       edit_resource_value: 100,
       without_sidebar: true
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
    {:noreply, assign(socket, action: id)}
  end

  def handle_event("edit_resource_change", %{}, socket) do
    IO.inspect("edit_resource_change")
    {:noreply, socket}
  end

  @spec handle_event(any, any, any) ::
          {any, any} | {:ok, any, any} | {:reply, any, any}
  def handle_event(action, attrs, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_event(
        action,
        attrs,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
