defmodule Meteorology.Integrations.OpenMeteo.HTTP.Client do
  @moduledoc """
  Cliente HTTP para integração com OpenMeteo, usando Finch.
  """
  @behaviour Meteorology.Integrations.OpenMeteo.HTTP.Behaviour

  @finch MeteorologyFinch

  @impl true
  def get(url) do
    case Finch.build(:get, url) |> Finch.request(@finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Finch.Response{status: status}} ->
        {:error, {:unexpected_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
