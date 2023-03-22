defmodule Bonfire.Upcycle.ResourceLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  import Bonfire.Upcycle.Integration

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(%{"id" => id} = _params, _session, socket) do
    resource = economic_resource(%{id: id}, socket) |> debug("theresource")
    name = e(resource, :name, nil)

    {:ok,
     assign(
       socket,
       page_title: name,
       id: ulid(resource),
       resource: resource,
       current_url: path(resource),
       editable: involved?(resource, socket),
       #  unit: unit,
       # TODO
       organizations: [],
       feed_title: name,
       without_sidebar: true
     )}
  end

  @graphql """
  query($id: ID) {
    economic_resource(id: $id) {
      id
      name
      note
      image
      # updated_at
      # conforms_to{
      #   id
      #   name
      # }
      primary_accountable {
        id
        display_username
        name
        image
        primary_location {
          name
        }
      }
      # accounting_quantity {
      #   has_numerical_value
      #   has_unit {
      #     id
      #     label
      #     symbol
      #   }
      # }
      onhand_quantity {
        has_numerical_value
        has_unit {
          id
          label
          symbol
        }
      }
      current_location {
        name
      }
    }
  }
  """
  def economic_resource(params \\ %{}, socket), do: liveql(socket, :economic_resource, params)

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__
          # &do_handle_event/3
        )
end
