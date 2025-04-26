defmodule Meteorology.MaxTemperatureAverageTest do
  use ExUnit.Case
  import Mox

  alias Meteorology.MaxTemperatureAverage
  alias Meteorology.Integrations.OpenMeteo.HTTP.MockClient

  setup :set_mox_from_context
  setup :verify_on_exit!

  @mock_response %{
    "daily" => %{
      "temperature_2m_max" => [24.5, 25.0, 26.0, 23.5, 22.0, 24.0]
    }
  }

  test "returns average temperatures for all cities" do
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(@mock_response)} end)

    result = MaxTemperatureAverage.calculate_averages()

    assert length(result) == 3

    Enum.each(result, fn
      {city, temp} when is_float(temp) ->
        assert temp == Enum.sum(@mock_response["daily"]["temperature_2m_max"]) / 6

      _ ->
        flunk("Expected float temperature average")
    end)
  end

  test "returns :insufficient_data if less than 6 values" do
    response = %{"daily" => %{"temperature_2m_max" => [22.0, 23.0]}}
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(response)} end)

    [{_city, result}] = MaxTemperatureAverage.calculate_averages()

    assert result == :insufficient_data
  end

  test "returns :wrong_data for unexpected structure" do
    bad_response = %{"unexpected" => "data"}
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(bad_response)} end)

    [{_city, result}] = MaxTemperatureAverage.calculate_averages()

    assert result == :wrong_data
  end

  test "returns {:error, reason} on API error" do
    expect(MockClient, :get, 3, fn _url -> {:error, :timeout} end)

    [{_city, result}] = MaxTemperatureAverage.calculate_averages()

    assert result == {:error, :timeout}
  end
end
