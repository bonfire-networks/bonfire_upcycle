defmodule Bonfire.Upcycle.Web.ResourceLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}

  alias Bonfire.Web.LivePlugs
  import Bonfire.Web.Gettext

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(%{"id" => id}, _session, socket) do
    {:ok, resource} = ValueFlows.EconomicResource.EconomicResources.one({:id, id})
    resource = Bonfire.Repo.preload(resource, :accounting_quantity)
    resource = Bonfire.Repo.preload(resource, :primary_accountable)
    resource = Bonfire.Repo.preload(resource, :image)
    unit = Bonfire.Repo.preload(resource.accounting_quantity, :unit).unit
    user = resource.primary_accountable |> Bonfire.Repo.preload(:accounted)
    user = user |> Bonfire.Repo.preload(:character)
    user = user |> Bonfire.Repo.preload(:profile)
    {:ok, account} = Bonfire.Me.Accounts.fetch_current(user.accounted.account_id)
    organizations = Bonfire.Me.SharedUsers.by_account(account)
    title = resource.name

    {:ok, socket
    |> assign(
      page_title: resource.name,
      resource: resource,
      unit: unit,
      user: user,
      organizations: organizations,
      feed_title: title
    )}
  end

  defdelegate handle_params(params, attrs, socket), to: Bonfire.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def get_last_activity(date) do
    week = case Date.day_of_week(date) do
      1 -> "Mon"
      2 -> "Tue"
      3 -> "Wed"
      4 -> "Thu"
      5 -> "Fri"
      6 -> "Sat"
      7 -> "Sun"
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
      12 -> "Dec"
    end

    "#{week} #{month} #{date.day} #{date.year}"
  end
end
