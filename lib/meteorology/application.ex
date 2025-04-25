defmodule Meteorology.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Finch, name: MeteorologyFinch}
    ]

    opts = [strategy: :one_for_one, name: Meteorology.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
