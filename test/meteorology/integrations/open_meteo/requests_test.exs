defmodule Meteorology.Integrations.OpenMeteo.HTTP.RequestsTest do
  use ExUnit.Case

  import Mox
  alias Meteorology.Integrations.OpenMeteo.HTTP.Requests
  alias Meteorology.Integrations.OpenMeteo.HTTP.MockClient

  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "get_max_temperature/4" do
    @success_body """
    {
      "latitude": -23.5,
      "longitude": -46.5,
      "daily": {
        "temperature_2m_max": [22.8, 24.3, 26.8]
      }
    }
    """

    test "returns parsed JSON when request is successful" do
      expect(MockClient, :get, fn url ->
        assert String.contains?(url, "latitude=-23.55")
        assert String.contains?(url, "longitude=-46.63")
        assert String.contains?(url, "timezone=America/Sao_Paulo")
        {:ok, @success_body}
      end)

      assert {:ok, parsed} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo")

      assert %{"daily" => %{"temperature_2m_max" => [22.8, 24.3, 26.8]}} = parsed
    end

    test "returns error when API responds with non-200 status" do
      expect(MockClient, :get, fn _url ->
        {:error, {:unexpected_status, 400}}
      end)

      assert {:error, {:unexpected_status, 400}} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo")
    end

    test "returns error on request timeout" do
      expect(MockClient, :get, fn _url ->
        {:error, :timeout}
      end)

      assert {:error, :timeout} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo")
    end
  end
end
