defmodule Bonfire.Upcycle do
  @moduledoc "./README.md" |> File.stream!() |> Enum.drop(1) |> Enum.join()

  use Arrows
  use Bonfire.Common.Utils

  # def repo, do: Bonfire.Common.Config.repo()

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  def remote_tag_prefix, do: nil
  # def remote_tag_prefix, do: "https://bonjour.bonfire.cafe/pub/actors/" # TODO: put in config

  def remote_tag_id, do: "#{remote_tag_prefix()}Needs_Offers"

  def format_date(date) when not is_nil(date) do
    Calendar.strftime(date, "%a, %B %d %Y")
  end

  def format_date(_), do: nil

  def units() do
    Bonfire.Quantify.Units.many()
    ~> Enum.map(&{&1.label, &1.id})
  end

  def involved?(resource, context) do
    Types.ulid(current_user(context)) in [
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
