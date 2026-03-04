defmodule PhiaDemoWeb.Router do
  use PhiaDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhiaDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhiaDemoWeb do
    pipe_through :browser

    live "/",           DashboardLive.Overview,    :index
    live "/analytics",  DashboardLive.Analytics,   :index
    live "/users",      DashboardLive.Users,        :index
    live "/orders",     DashboardLive.Orders,       :index
    live "/components", DashboardLive.Components,   :index
    live "/settings",   DashboardLive.Settings,     :index
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:phia_demo, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhiaDemoWeb.Telemetry
    end
  end
end
