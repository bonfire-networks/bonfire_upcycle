defmodule Bonfire.Upcycle.Web.InventoryLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}
  alias Bonfire.Web.LivePlugs

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

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
end