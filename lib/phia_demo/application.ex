defmodule PhiaDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhiaDemoWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phia_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhiaDemo.PubSub},
      # Start a worker by calling: PhiaDemo.Worker.start_link(arg)
      # {PhiaDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      PhiaDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhiaDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhiaDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
