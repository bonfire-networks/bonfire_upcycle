defmodule Bonfire.Upcycle.Web.InventoryLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  import Bonfire.Upcycle.Integration
  alias Bonfire.UI.Me.LivePlugs

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  declare_nav_link(l("Inventory"), icon: "ph:ladder")

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
    resources = my_agent(socket).inventoried_economic_resources

    {:ok,
     assign(
       socket,
       user: current_user,
       page_title: l("Inventory"),
       resources: resources,
       create_object_type: :upcycle_resource,
       smart_input_prompt: l("New resource"),
       changeset: ValueFlows.EconomicEvent.validate_changeset(),
       action: "raise",
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.UI.ValueFlows.FilterIntentsLive, []}
           ]
         ],
         guests: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ]
       ]
     )}
  end

  @graphql """
  query {
    my_agent {
      inventoried_economic_resources {
        id
        name
        note
        image
        conforms_to{
          id
          name
        }
        primary_accountable {
          id
          display_username
          name
          image
        }
        onhand_quantity {
          has_numerical_value
          has_unit {
            id
            label
            symbol
          }
        }
        conforms_to {
          name
        }
        current_location {
          display_username
          canonical_url
        }
      }
    }
  }
  """
  def my_agent(params \\ %{}, socket), do: liveql(socket, :my_agent, params)

  def handle_event("toggle_action", %{"id" => id}, socket) do
    debug(id)
    {:noreply, assign(socket, action: id)}
  end

  # def handle_event("edit_resource_change", %{}, socket) do
  #   IO.inspect("edit_resource_change")
  #   {:noreply, socket}
  # end

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
