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

    test "retorna JSON parseado quando a requisição é bem-sucedida" do
      expect(MockClient, :get, fn url ->
        assert String.contains?(url, "latitude=-23.55")
        assert String.contains?(url, "longitude=-46.63")
        assert String.contains?(url, "timezone=America%2FSao_Paulo")
        {:ok, @success_body}
      end)

      assert {:ok, parsed} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo", MockClient)

      assert %{"daily" => %{"temperature_2m_max" => [22.8, 24.3, 26.8]}} = parsed
    end

    test "retorna erro quando a API retorna status diferente de 200" do
      expect(MockClient, :get, fn _url ->
        {:error, {:unexpected_status, 400}}
      end)

      assert {:error, {:unexpected_status, 400}} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo", MockClient)
    end

    test "retorna erro quando há timeout na requisição" do
      expect(MockClient, :get, fn _url ->
        {:error, :timeout}
      end)

      assert {:error, :timeout} =
               Requests.get_max_temperature(-23.55, -46.63, "America/Sao_Paulo", MockClient)
    end
  end

  describe "build_url/3" do
    test "constrói URL corretamente com parâmetros básicos" do
      url = Requests.build_url(-23.55, -46.63, "America/Sao_Paulo")

      assert url ==
               "https://api.open-meteo.com/v1/forecast?" <>
                 "latitude=-23.55&longitude=-46.63&" <>
                 "daily=temperature_2m_max&" <>
                 "timezone=America%2FSao_Paulo"
    end

    test "codifica caracteres especiais no timezone" do
      url = Requests.build_url(-23.55, -46.63, "America/New_York")
      assert String.contains?(url, "timezone=America%2FNew_York")
    end
  end

  describe "parse_response/1" do
    test "parseia resposta JSON válida" do
      json = "{\"key\": \"value\"}"
      assert {:ok, %{"key" => "value"}} = Requests.parse_response({:ok, json})
    end

    test "retorna erro para JSON inválido" do
      assert {:error, {:invalid_json, _}} = Requests.parse_response({:ok, "invalid"})
    end

    test "retorna erro inalterado" do
      assert {:error, :some_error} = Requests.parse_response({:error, :some_error})
    end
  end
end
