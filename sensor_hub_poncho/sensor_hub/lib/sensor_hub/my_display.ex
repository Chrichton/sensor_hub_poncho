defmodule SensorHub.MyDisplay do
  use OLED.Display, app: :sensor_hub

  require Logger

  @spec print(Map.t()) :: Map.t()
  def print(map) do
    Logger.info("print()")

    co2 =
      map[:co2_eq_ppm]
      |> Integer.to_string()

    tvoc =
      map[:tvoc_ppb]
      |> Integer.to_string()

    temperature_c =
      map[:temperature_c]
      |> Float.round(1)
      |> to_string()

    pressure_bar =
      (map[:pressure_pa] / 100)
      |> round()
      |> to_string()

    path =
      :code.priv_dir(:sensor_hub)
      |> to_string()
      |> then(fn priv_dir -> Path.absname("9x15.bdf", priv_dir) end)

    {:ok, font} = Chisel.Font.load(path)

    put_pixel = fn x, y ->
      put_pixel(x, y)
    end

    clear()
    Chisel.Renderer.draw_text("Co2:" <> co2, 0, 0, font, put_pixel)
    Chisel.Renderer.draw_text("tvoc:" <> tvoc, 64, 0, font, put_pixel)
    Chisel.Renderer.draw_text("#{temperature_c}°C", 0, 16, font, put_pixel)
    Chisel.Renderer.draw_text("#{pressure_bar} bar", 64, 16, font, put_pixel)
    display()

    map
  end
end
