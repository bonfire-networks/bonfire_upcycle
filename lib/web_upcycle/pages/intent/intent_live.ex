defmodule Bonfire.Upcycle.IntentLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  import Bonfire.Upcycle.Integration

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive
  alias Bonfire.UI.Me.LoggedDashboardLive

  prop selected_tab, :string, default: "discover"

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(%{"id" => id} = _params, _session, socket) do
    intent =
      intent(%{id: id}, socket)
      |> debug("theintent")

    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
      intent =
        intent
        |> Map.put(:is_offer, e(intent, :provider, nil) != nil)
        |> Map.put(:is_need, e(intent, :receiver, nil) != nil)

      {:ok,
       assign(
         socket,
         page_title: if(intent.is_offer, do: l("Offer"), else: l("Need")),
         without_sidebar: true,
         id: ulid(intent),
         intent: intent,
         reply_to_id: intent,
         object_type_readable: if(intent.is_offer, do: l("offer"), else: l("need")),
         current_url: path(intent),
         #  create_object_type: :upcycle_intent, # TODO: reply with an intent
         smart_input_opts: %{
           prompt: if(intent.is_offer, do: l("Respond to offer"), else: l("Respond to need"))
         },
         matches: ValueFlows.Util.search_for_matches(intent)
         #  without_sidebar: true
       )}

      # |> IO.inspect
    end
  end

  @graphql """
    query($id: ID) {
      intent(id: $id) {
        id
        name
        note
        image
        due
        finished
        resource_inventoried_as {
          id
          name
          image
          note
        }
        has_beginning
        resource_quantity {
          id
          has_numerical_value
          has_unit {
            label
          }
        }
        at_location {
          id
          name
        }
        provider {
          id
          name
          display_username
          image
          primary_location {
            id
            name
          }
        }
        receiver {
          id
          name
          display_username
          image
          primary_location {
            id
            name
          }
        }
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)

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
