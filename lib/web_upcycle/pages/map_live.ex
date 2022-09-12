defmodule Bonfire.Upcycle.MapLive do
  use Bonfire.UI.Common.Web, :live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.Me.LivePlugs

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

  defp mounted(params, session, socket) do
    # intents = Bonfire.Upcycle.ProposalLive.all_intents(socket)
    # IO.inspect(intents)

    {:ok,
     assign(
       socket,
       page_title: "Map",
       selected_tab: "about",
       markers: [],
       points: [],
       place: nil,
       main_labels: []
     )}
  end

  def fetch_place_things(filters, socket) do
    with {:ok, things} <-
           ValueFlows.Planning.Intent.Intents.many(filters) do
      IO.inspect(things)

      things =
        Enum.map(
          things,
          &Map.merge(
            Bonfire.Geolocate.Geolocations.populate_coordinates(Map.get(&1, :at_location)),
            &1 || %{}
          )
        )

      IO.inspect(things)

      things
    else
      e ->
        IO.inspect(error: e)
        nil
    end
  end

  # proxy relevent events to the map component
  def handle_event("map_" <> _action = event, params, socket) do
    IO.inspect(proxy_event: event)
    IO.inspect(proxy_params: params)
    Bonfire.Geolocate.MapLive.handle_event(event, params, socket, true)
  end
end
