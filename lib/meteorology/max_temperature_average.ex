defmodule Meteorology.MaxTemperatureAverage do
  @moduledoc """
  Calculates the average max temperature for the next 6 days across predefined cities.
  """

  alias Meteorology.Integrations.OpenMeteo.HTTP.Requests

  @cities [
    %{name: "São Paulo", latitude: -23.55, longitude: -46.63},
    %{name: "Belo Horizonte", latitude: -19.92, longitude: -43.94},
    %{name: "Curitiba", latitude: -25.43, longitude: -49.27}
  ]

  def calculate_averages do
    @cities
    |> Enum.map(&fetch_data_async/1)
    |> Task.await_many()
  end

  defp fetch_data_async(city) do
    Task.async(fn ->
      case Requests.get_max_temperature(city.latitude, city.longitude, get_local_timezone()) do
        {:ok, %{"daily" => %{"temperature_2m_max" => temps}}} ->
          calculate_average(city.name, temps)

        {:ok, _} ->
          {city.name, :wrong_data}

        {:error, reason} ->
          {city.name, {:error, reason}}
      end
    end)
  end

  defp calculate_average(city_name, temps) when is_list(temps) do
    first_6_days = Enum.take(temps, 6)

    if length(first_6_days) < 6 do
      IO.warn("[#{city_name}] Insufficient data points (#{length(first_6_days)}/6)")
      {city_name, :insufficient_data}
    else
      average = Enum.sum(first_6_days) / 6
      {city_name, average}
    end
  end

  defp calculate_average(city_name, :wrong_data) do
    {city_name, :wrong_data}
  end

  defp calculate_average(city_name, {:error, reason}) do
    IO.warn("[#{city_name}] API Error: #{inspect(reason)}")
    {city_name, :error}
  end

  defp get_local_timezone do
    case Timex.local() do
      %DateTime{time_zone: tz} -> tz
      _ -> "America/Sao_Paulo"
    end
  end
end
