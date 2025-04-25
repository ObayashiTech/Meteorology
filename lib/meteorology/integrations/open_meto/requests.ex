defmodule Meteorology.Integrations.OpenMeteo.HTTP.Requests do
  alias Meteorology.Integrations.OpenMeteo.HTTP.Client

  @base_url "https://api.open-meteo.com/v1/forecast"

  def get_max_temperature(latitude, longitude, timezone, client \\ Client) do
    url = build_url(latitude, longitude, timezone)

    client.get(url)
    |> parse_response()
  end

  defp build_url(latitude, longitude, timezone) do
    URI.encode(
      "#{@base_url}?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max&timezone=#{timezone}"
    )
  end

  defp parse_response({:ok, body}) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, parsed} -> {:ok, parsed}
      {:error, reason} -> {:error, {:invalid_json, reason}}
    end
  end

  defp parse_response(error), do: error
end
