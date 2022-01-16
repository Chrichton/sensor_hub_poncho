defmodule SensorHub.SGP30Impl do
  alias SensorHub.MyDisplay

  require Logger

  def print(map) do
    co2 =
      map[:co2_eq_ppm]
      |> Integer.to_string()

    path =
      :code.priv_dir(:sensor_hub)
      |> to_string()
      |> then(fn priv_dir -> Path.absname("5x8.bdf", priv_dir) end)

    {:ok, font} = Chisel.Font.load(path)

    put_pixel = fn x, y ->
      MyDisplay.put_pixel(x, y)
    end

    Chisel.Renderer.draw_text(co2, 0, 0, font, put_pixel)
    MyDisplay.display()
    :ok
  end
end
