defmodule HV3D.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HV3D.Worker.start_link(arg)
      # {HV3D.Worker, arg}
      HV3D.Consumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HV3D.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
