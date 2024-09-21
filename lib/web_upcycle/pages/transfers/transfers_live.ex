defmodule Bonfire.Upcycle.Web.TransfersLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  prop action, :any, default: "transfer"

  declare_nav_link(l("Transfers"), icon: "tabler:arrows-exchange")

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, session, socket) do
    current_user = current_user(assigns(socket))
    my_agent = my_agent(socket)

    {:ok,
     assign(
       socket,
       user: current_user,
       changeset: ValueFlows.EconomicEvent.validate_changeset(),
       action: "transfer",
       create_object_type: :upcycle_transfer,
       economic_events: e(my_agent, :economic_events, []),
       #  resources: resources,
       smart_input_opts: %{
         prompt: l("Record a transfer"),
         resources: e(my_agent, :inventoried_economic_resources, [])
       }
       #  resource_id: 0,
       #  resource_name: "",
       #  resource_quantity: 0,
       #  without_sidebar: true
     )}
  end

  @graphql """
  query {
    my_agent {
      id
      display_username
      primary_location {
        display_username
      }
      inventoried_economic_resources {
        id
        name
        onhand_quantity {
          has_numerical_value
          has_unit
        }
      }
      economic_events {
        id
        note
        action {
          id
          label
          note
          onhand_effect
          resource_effect
        }
        at_location {
          name
        }
        provider {
          agent_type
          canonical_url
          display_username
          id
          image
          name
        }
        receiver {
          agent_type
          canonical_url
          display_username
          id
          image
          name
        }
        resource_inventoried_as {
          id
          image
          name
          note
          conforms_to {
            name
          }
          accounting_quantity {
            has_numerical_value
            has_unit {
              label
              symbol
            }
          }
          onhand_quantity {
            has_numerical_value
            has_unit {
              label
              symbol
            }
          }
        }
        to_resource_inventoried_as {
          id
          image
          name
          note
          conforms_to {
            name
          }
          accounting_quantity {
            has_numerical_value
            has_unit {
              label
              symbol
            }
          }
          onhand_quantity {
            has_numerical_value
            has_unit {
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
end
