defmodule PhiaDemoWeb.PageController do
  use PhiaDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
