defmodule Meteorology.Integrations.OpenMeteo.HTTP.Behaviour do
  @moduledoc """
  Define o comportamento esperado de um client HTTP para OpenMeteo.
  """

  @callback get(String.t()) :: {:ok, String.t()} | {:error, any()}
end
