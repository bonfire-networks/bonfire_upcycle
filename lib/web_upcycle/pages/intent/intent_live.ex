defmodule Bonfire.Upcycle.IntentLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  import Bonfire.Upcycle.Integration

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive
  alias Bonfire.UI.Me.LoggedDashboardLive

  prop selected_tab, :string, default: "discover"

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

  defp mounted(%{"id" => id} = _params, _session, socket) do
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
         page_title: "Intent",
         without_sidebar: true,
         intent: intent,
         reply_to_id: ulid(intent),
         smart_input_prompt:
           if(intent.is_offer, do: l("Respond to offer"), else: l("Respond to need")),
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
        }
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)

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
