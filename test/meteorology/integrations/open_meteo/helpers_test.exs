defmodule Meteorology.Integrations.OpenMeteo.HTTP.HelperTest do
  use ExUnit.Case

  alias Meteorology.Integrations.OpenMeteo.HTTP.Helpers

  describe "build_url/3" do
    test "builds URL correctly with basic parameters" do
      url = Helpers.build_url(-23.55, -46.63, "America/Sao_Paulo")

      assert url ==
               "https://api.open-meteo.com/v1/forecast?" <>
                 "latitude=-23.55&longitude=-46.63&" <>
                 "daily=temperature_2m_max&" <>
                 "timezone=America/Sao_Paulo"
    end

    test "encodes special characters in timezone" do
      url = Helpers.build_url(-23.55, -46.63, "America/New_York")
      assert String.contains?(url, "timezone=America/New_York")
    end
  end

  describe "parse_response/1" do
    test "parses valid JSON response" do
      json = "{\"key\": \"value\"}"
      assert {:ok, %{"key" => "value"}} = Helpers.parse_response({:ok, json})
    end

    test "returns error for invalid JSON" do
      assert {:error, {:invalid_json, _}} = Helpers.parse_response({:ok, "invalid"})
    end

    test "returns unchanged error" do
      assert {:error, :some_error} = Helpers.parse_response({:error, :some_error})
    end
  end
end
