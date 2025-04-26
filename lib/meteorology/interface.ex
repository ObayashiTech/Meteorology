defmodule Meteorology.Interface do
  @moduledoc """
  Interactive command-line interface.
  """
  def execute do
    IO.puts("""
    ==================================
       Welcome to the Meteorology CLI!
    ==================================
    """)

    menu()
  end

  defp menu do
    IO.puts("\nWhat would you like to do?")
    IO.puts("1 - View average max temperatures")
    IO.puts("2 - Exit")

    case IO.gets("Enter your choice: ") |> String.trim() do
      "1" ->
        show_results()
        menu()

      "2" ->
        IO.puts("Exit")

      _ ->
        IO.puts("Invalid option. Please try again.")
        menu()
    end
  end

  def show_results do
    IO.puts("\nFetching data and calculating averages...\n")

    Meteorology.MaxTemperatureAverage.execute()
    |> Enum.each(fn
      {city, avg} when is_float(avg) ->
        IO.puts("#{city}: #{Float.round(avg, 1)}°C")

      {city, _} ->
        IO.puts("#{city}: Data not available")
    end)
  end
end
