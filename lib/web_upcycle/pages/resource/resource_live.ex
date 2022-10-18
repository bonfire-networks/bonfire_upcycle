defmodule Bonfire.Upcycle.Web.ResourceLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.Me.LivePlugs
  import Bonfire.Upcycle.Integration

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(%{"id" => id}, _session, socket) do
    {:ok, resource} = resource({:id, id})

    {:ok,
     assign(
       socket,
       page_title: resource.name,
       resource: resource,
       #  unit: unit,
       # TODO
       user: nil,
       organizations: [],
       feed_title: resource.name
       #  without_sidebar: true
     )}
  end

  @graphql """
  query($id: ID) {
    economic_resource(id: $id) {
      id
      name
      note
      image
      conforms_to{
        id
        name
      }
      primary_accountable {
        display_username
        name
        image
      }
      onhand_quantity {
        has_numerical_value
        has_unit {
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
  """
  def resource(params \\ %{}, socket), do: liveql(socket, :economic_resource, params)

  defdelegate handle_params(params, attrs, socket),
    to: Bonfire.UI.Common.LiveHandlers

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
