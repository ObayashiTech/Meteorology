defmodule Meteorology.InterfaceTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mox

  alias Meteorology.Interface
  alias Meteorology.Integrations.OpenMeteo.HTTP.MockClient

  setup :set_mox_from_context
  setup :verify_on_exit!

  @mock_response %{
    "daily" => %{
      "temperature_2m_max" => [24.5, 25.0, 26.0, 23.5, 22.0, 24.0]
    }
  }

  test "shows welcome message and exits when choosing option 2" do
    output =
      capture_io([input: "2\n"], fn ->
        Interface.execute()
      end)

    assert output =~ "Welcome to the Meteorology CLI"
    assert output =~ "What would you like to do?"
    assert output =~ "Exit"
  end

  test "displays average temperatures when choosing option 1" do
    expect(MockClient, :get, 3, fn _url -> {:ok, Jason.encode!(@mock_response)} end)

    output =
      capture_io([input: "1\n2\n"], fn ->
        Interface.execute()
      end)

    assert output =~ "Fetching data and calculating averages..."
    assert output =~ "São Paulo"
    assert output =~ "Belo Horizonte"
    assert output =~ "Curitiba"
    assert output =~ "°C"
  end

  test "displays invalid option message" do
    output =
      capture_io([input: "99\n2\n"], fn ->
        Interface.execute()
      end)

    assert output =~ "Invalid option. Please try again."
    assert output =~ "Exit"
  end
end
