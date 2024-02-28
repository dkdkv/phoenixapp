defmodule Phoenixapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixappWeb.Telemetry,
      Phoenixapp.Repo,
      {DNSCluster, query: Application.get_env(:phoenixapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phoenixapp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Phoenixapp.Finch},
      # Start a worker by calling: Phoenixapp.Worker.start_link(arg)
      # {Phoenixapp.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixappWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phoenixapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
