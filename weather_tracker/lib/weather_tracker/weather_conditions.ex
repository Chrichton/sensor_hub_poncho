defmodule WeatherTracker.WeatherConditions do
  alias WeatherTracker.{
    Repo,
    WeatherConditions.WeatherCondition
  }

  def create_entry(attrs) do
    attrs = Map.put(attrs, "light_lumens", 42)

    %WeatherCondition{}
    |> WeatherCondition.create_changeset(attrs)
    |> Repo.insert()
  end
end
