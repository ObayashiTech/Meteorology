defmodule Meteorology.Integrations.OpenMeteo.HTTP.Requests do
  @moduledoc """
  Provides high-level HTTP request functions for interacting with the Open-Meteo API.
  """

  alias Meteorology.Integrations.OpenMeteo.HTTP.{Client, Helpers}

  def get_max_temperature(latitude, longitude, timezone, client \\ Client) do
    latitude
    |> Helpers.build_url(longitude, timezone)
    |> client.get()
    |> Helpers.parse_response()
  end
end
