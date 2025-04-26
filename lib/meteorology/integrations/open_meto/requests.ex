defmodule Meteorology.Integrations.OpenMeteo.HTTP.Requests do
  @moduledoc """
  Provides high-level HTTP request functions for interacting with the Open-Meteo API.
  """

  alias Meteorology.Integrations.OpenMeteo.HTTP.Helpers

  def get_max_temperature(latitude, longitude, timezone) do
    latitude
    |> Helpers.build_url(longitude, timezone)
    |> client().get()
    |> Helpers.parse_response()
  end

  defp client do
    case Mix.env() do
      :test ->
        Meteorology.Integrations.OpenMeteo.HTTP.MockClient

      _ ->
        Meteorology.Integrations.OpenMeteo.HTTP.Client
    end
  end
end
