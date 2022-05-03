defmodule Bonfire.Upcycle.Web.TransferLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}
  alias Bonfire.Web.LivePlugs

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  prop action, :any, default: "transfer"

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
    economic_events = my_agent(socket).myAgent.economicEvents
    resources = my_agent(socket).myAgent.inventoriedEconomicResources

    {:ok, socket
    |> assign(
      user: current_user,
      changeset: ValueFlows.EconomicEvent.validate_changeset(),
      action: "transfer",
      economic_events: economic_events,
      resources: resources,
      resource_id: 0,
      resource_name: "",
      resource_quantity: 0
    )}
  end

  @graphql """
  query {
    myAgent {
      id
      displayUsername
      primaryLocation {
        displayUsername
      }
      inventoriedEconomicResources {
        id
        name
        onhandQuantity {
          hasNumericalValue
          hasUnit
        }
      }
      economicEvents {
        id
        note
        action {
          id
          label
          note
          onhandEffect
          resourceEffect
        }
        atLocation {
          name
        }
        provider {
          agentType
          canonicalUrl
          displayUsername
          id
          image
          name
        }
        receiver {
          agentType
          canonicalUrl
          displayUsername
          id
          image
          name
        }
        resourceInventoriedAs {
          id
          image
          name
          conformsTo {
            name
          }
          accountingQuantity {
            hasNumericalValue
            hasUnit {
              label
              symbol
            }
          }
          onhandQuantity {
            hasNumericalValue
            hasUnit {
              label
              symbol
            }
          }
        }
      }
    }
  }
  """
  def my_agent(params \\ %{}, socket), do: liveql(socket, :my_agent, params)

  def handle_event("resource_click", %{"id" => id, "name" => name, "quantity" => quantity}, socket) do
    IO.puts("lolXD")
    IO.inspect(socket)
    {:noreply,
      socket |> assign(resource_id: id, resource_name: name, resource_quantity: quantity)}
  end

  @spec handle_event(any, any, any) :: {any, any} | {:ok, any, any} | {:reply, any, any}
  def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
