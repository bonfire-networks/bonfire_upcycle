defmodule Bonfire.Upcycle.Integration do
  use Arrows
  import Bonfire.Common.Utils

  # def repo, do: Bonfire.Common.Config.repo()

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  # TODO: put in config
  def remote_tag_id, do: "https://bonjour.bonfire.cafe/pub/actors/Needs_Offers"

  def format_date(date) when not is_nil(date) do
    Calendar.strftime(date, "%a, %B %d %Y")
  end

  def format_date(_), do: nil

  def units() do
    Bonfire.Quantify.Units.many()
    ~> Enum.map(&{&1.label, &1.id})
  end

  def involved?(resource, context) do
    ulid(current_user(context)) in [
      e(resource, :provider, :id, nil),
      e(resource, :provider_id, nil),
      e(resource, :receiver, :id, nil),
      e(resource, :receiver_id, nil),
      e(resource, :primary_accountable, :id, nil),
      e(resource, :primary_accountable_id, nil),
      e(resource, :creator, :id, nil),
      e(resource, :creator_id, nil)
    ]
  end
end
