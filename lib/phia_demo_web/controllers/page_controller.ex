defmodule PhiaDemoWeb.PageController do
  use PhiaDemoWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/dashboard")
  end
end
