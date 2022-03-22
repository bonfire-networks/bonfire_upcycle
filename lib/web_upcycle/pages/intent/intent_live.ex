defmodule Bonfire.Upcycle.IntentLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}

  use AbsintheClient, schema: Bonfire.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.Web.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.Me.Web.{CreateUserLive, LoggedDashboardLive}

  prop selected_tab, :string, default: "discover"

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(%{"id"=> id} = _params, _session, socket) do
    intent = intent(%{id: id}, socket)
    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else

    intent = intent
    |> Map.put(:is_offer, e(intent, :provider, nil) != nil)
    |> Map.put(:is_need, e(intent, :receiver, nil) != nil)

    {:ok, socket
    |> assign(
      page_title: "Intent",
      intent: intent,
      matches: ValueFlows.Util.search_for_matches(intent)
    )} #|> IO.inspect
    end
  end

  @graphql """
  query($id: ID) {
    intent(id: $id) {
      id
      name
      note
      due
      finished
      resourceInventoriedAs {
        id
      }
      has_beginning
      resourceQuantity {
        id
        hasNumericalValue
      }
      atLocation {
        id
        name
      }
      provider {
        id
        name
        display_username
        image
        primaryLocation {
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


def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

defp get_creation_date(date) do
  week = case Date.day_of_week(date) do
    0 -> "Sun"
    1 -> "Mon"
    2 -> "Tue"
    3 -> "Wed"
    4 -> "Thu"
    5 -> "Fri"
    6 -> "Sat"
  end

  month = case date.month do
    1 -> "Jan"
    2 -> "Feb"
    3 -> "Mar"
    4 -> "Apr"
    5 -> "May"
    6 -> "Jun"
    7 -> "Jul"
    8 -> "Aug"
    9 -> "Sep"
    10 -> "Oct"
    11 -> "Nov"
    12 -> "Dev"
  end

  "#{week} #{month} #{date.day} #{date.year}"
end

end
