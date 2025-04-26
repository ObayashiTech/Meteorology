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

    result = MaxTemperatureAverage.execute()

    assert length(result) == 3

    Enum.each(result, fn
      {_city, temp} when is_float(temp) ->
        assert temp == Enum.sum(@mock_response["daily"]["temperature_2m_max"]) / 6

      _ ->
        flunk("Expected float temperature average")
    end)
  end

  test "returns :insufficient_data if less than 6 values" do
    response = %{"daily" => %{"temperature_2m_max" => [22.0, 23.0]}}
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(response)} end)

    result = MaxTemperatureAverage.execute()

    Enum.each(result, fn
      {_city, temp} ->
        assert temp == :insufficient_data
    end)
  end

  test "returns :wrong_data for unexpected structure" do
    bad_response = %{"unexpected" => "data"}
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(bad_response)} end)

    result = MaxTemperatureAverage.execute()

    Enum.each(result, fn
      {_city, temp} ->
        assert temp == :wrong_data
    end)
  end

  test "returns {:error, reason} on API error" do
    expect(MockClient, :get, 3, fn _url -> {:error, :timeout} end)

    result = MaxTemperatureAverage.execute()

    Enum.each(result, fn
      {_city, temp} ->
        assert temp == {:error, :timeout}
    end)
  end
end
