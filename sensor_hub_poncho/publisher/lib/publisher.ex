defmodule Publisher do
  use GenServer
  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: options[:interval] || 10_000,
      weather_tracker_url: options[:weather_tracker_url],
      sensors: options[:sensors],
      measurements: :no_measurements,
      display: options[:display]
    }

    schedule_next_publish(state.interval)
    {:ok, state}
  end

  defp schedule_next_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end

  @impl true
  def handle_info(:publish_data, state) do
    {:noreply, state |> measure() |> publish()}
  end

  defp measure(state) do
    measurements =
      Enum.reduce(state.sensors, %{}, fn sensor, acc ->
        sensor.read.()
        |> sensor.convert.()
        |> then(fn sensor_data -> Map.merge(acc, sensor_data) end)
      end)

    %{state | measurements: measurements}
  end

  defp publish(state) do
    state.display.print(state.measurements)

    Logger.debug("printed: #{inspect(state.measurements)}")

    schedule_next_publish(state.interval)
    state
  end
end
