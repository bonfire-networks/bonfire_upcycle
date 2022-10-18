defmodule Bonfire.Upcycle.Integration do
  use Arrows

  # def repo, do: Bonfire.Common.Config.get!(:repo_module)

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
end
