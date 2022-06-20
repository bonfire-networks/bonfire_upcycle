defmodule Bonfire.Upcycle.Web.ResourceLive do
  use Bonfire.UI.Common.Web, :surface_view

  alias Bonfire.UI.Me.LivePlugs
  import Bonfire.Upcycle.Integration

  def mount(params, session, socket) do
    live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(%{"id" => id}, _session, socket) do
    {:ok, resource} = ValueFlows.EconomicResource.EconomicResources.one({:id, id})
    resource = Bonfire.Common.Repo.preload(resource, :accounting_quantity)
    resource = Bonfire.Common.Repo.preload(resource, :primary_accountable)
    resource = Bonfire.Common.Repo.preload(resource, :image)
    unit = Bonfire.Common.Repo.preload(resource.accounting_quantity, :unit).unit
    user = resource.primary_accountable |> Bonfire.Common.Repo.preload(:accounted)
    user = user |> Bonfire.Common.Repo.preload(:character)
    user = user |> Bonfire.Common.Repo.preload(:profile)
    {:ok, account} = Bonfire.Me.Accounts.fetch_current(user.accounted.account_id)
    organizations = if module_enabled?(Bonfire.Data.SharedUser), do: Bonfire.Me.SharedUsers.by_account(account)
    title = resource.name

    {:ok, socket
    |> assign(
      page_title: resource.name,
      resource: resource,
      unit: unit,
      user: user,
      organizations: organizations,
      feed_title: title,
      without_sidebar: true
    )}
  end

  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)


end
