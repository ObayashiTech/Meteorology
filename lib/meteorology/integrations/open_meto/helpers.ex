defmodule Meteorology.Integrations.OpenMeteo.HTTP.Helpers do
  @moduledoc """
  Provides helper functions for building Open-Meteo API URLs and parsing responses.
  """

  @base_url "https://api.open-meteo.com/v1/forecast"

  def build_url(latitude, longitude, timezone) do
    URI.encode(
      "#{@base_url}?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max&timezone=#{timezone}"
    )
  end

  def parse_response({:ok, body}) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, parsed} -> {:ok, parsed}
      {:error, reason} -> {:error, {:invalid_json, reason}}
    end
  end

  def parse_response(error), do: error
end
