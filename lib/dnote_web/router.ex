defmodule DnoteWeb.Router do
  use DnoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DnoteWeb.IdentifyUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DnoteWeb do
    pipe_through :browser

    get "/", BoardController, :index
    get "/~:board", BoardController, :show

    get "/_labels", LabelController, :index
    get "/!:label", LabelController, :show

    get "/signup", AccountController, :new
    post "/signup", AccountController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", DnoteWeb do
  #   pipe_through :api
  # end
end
