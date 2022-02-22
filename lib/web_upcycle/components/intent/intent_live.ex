defmodule Bonfire.UI.Upcycle.IntentLive do
  use Bonfire.Web, :stateless_component

  prop resourceQuantity, :integer
  prop intent, :any

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
